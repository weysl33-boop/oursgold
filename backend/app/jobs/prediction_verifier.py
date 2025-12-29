"""Prediction verification background job (Task 1.7.8)"""
import logging
from typing import Optional, List
from datetime import datetime
from decimal import Decimal

from app.jobs.base import BaseJob

logger = logging.getLogger(__name__)


class PredictionVerifierJob(BaseJob):
    """
    Background job for prediction verification at deadline.

    Implements Task 1.7.8: Create background job for prediction verification at deadline

    Responsibilities:
    - Check predictions where verify_time <= NOW() and status = 'active'
    - Fetch current price at verification time
    - Calculate price change percentage
    - Determine correct answer based on verification rules
    - Update prediction and vote records
    - Update user prediction statistics (accuracy, streak)
    - Broadcast verification results via WebSocket
    - Send push notifications to participants
    """

    def __init__(
        self,
        prediction_repository=None,
        vote_repository=None,
        user_stats_repository=None,
        market_data_service=None,
        websocket_manager=None,
        notification_service=None,
    ):
        """
        Initialize the prediction verifier job.

        Args:
            prediction_repository: Repository for prediction data
            vote_repository: Repository for vote data
            user_stats_repository: Repository for user prediction stats
            market_data_service: Service to fetch current market prices
            websocket_manager: Manager to broadcast verification results
            notification_service: Service to send push notifications
        """
        super().__init__(interval_seconds=60)  # Run every 1 minute
        self.prediction_repository = prediction_repository
        self.vote_repository = vote_repository
        self.user_stats_repository = user_stats_repository
        self.market_data_service = market_data_service
        self.websocket_manager = websocket_manager
        self.notification_service = notification_service

    async def execute(self) -> None:
        """Verify predictions that have reached their deadline"""
        try:
            # Find predictions that need verification
            predictions = await self._find_predictions_to_verify()

            if not predictions:
                logger.debug("No predictions to verify")
                return

            logger.info(f"Verifying {len(predictions)} predictions")

            for prediction in predictions:
                try:
                    await self._verify_prediction(prediction)
                except Exception as e:
                    logger.error(
                        f"Failed to verify prediction {prediction.get('id')}: {str(e)}",
                        exc_info=True
                    )

            logger.info("Prediction verification completed")

        except Exception as e:
            logger.error(f"Error in prediction verification job: {str(e)}", exc_info=True)

    async def _find_predictions_to_verify(self) -> List[dict]:
        """
        Find predictions that need verification.

        Returns:
            List of predictions where verify_time has passed and status is active
        """
        if not self.prediction_repository:
            logger.warning("Prediction repository not configured")
            return []

        try:
            now = datetime.utcnow()
            predictions = await self.prediction_repository.find_by_criteria({
                "verify_time__lte": now,
                "status": "active"
            })

            return predictions

        except Exception as e:
            logger.error(f"Failed to find predictions to verify: {str(e)}")
            return []

    async def _verify_prediction(self, prediction: dict) -> None:
        """
        Verify a single prediction.

        Args:
            prediction: Prediction data
        """
        prediction_id = prediction.get("id")
        symbol_code = prediction.get("symbol_code")
        price_at_create = Decimal(str(prediction.get("price_at_create", 0)))

        logger.info(f"Verifying prediction {prediction_id} for {symbol_code}")

        # Step 1: Fetch current price
        current_price = await self._fetch_current_price(symbol_code)
        if not current_price:
            logger.error(f"Failed to fetch price for {symbol_code}")
            return

        # Step 2: Calculate price change percentage
        price_change_percent = self._calculate_price_change(
            price_at_create, current_price
        )

        logger.info(
            f"Price at create: {price_at_create}, "
            f"Current price: {current_price}, "
            f"Change: {price_change_percent}%"
        )

        # Step 3: Determine correct answer
        correct_option = await self._determine_correct_option(
            prediction, price_change_percent
        )

        if not correct_option:
            logger.error(f"Failed to determine correct option for {prediction_id}")
            return

        logger.info(f"Correct option: {correct_option}")

        # Step 4: Update prediction record
        await self._update_prediction(
            prediction_id, current_price, correct_option
        )

        # Step 5: Update all vote records
        await self._update_votes(prediction_id, correct_option)

        # Step 6: Update user statistics
        await self._update_user_statistics(prediction_id)

        # Step 7: Broadcast verification result
        await self._broadcast_verification(prediction, correct_option, current_price)

        # Step 8: Send notifications to participants
        await self._send_notifications(prediction, correct_option)

        logger.info(f"Successfully verified prediction {prediction_id}")

    async def _fetch_current_price(self, symbol_code: str) -> Optional[Decimal]:
        """
        Fetch current market price for a symbol.

        Args:
            symbol_code: Symbol to fetch price for

        Returns:
            Current price as Decimal or None if failed
        """
        if not self.market_data_service:
            logger.warning("Market data service not configured")
            return None

        try:
            quote = await self.market_data_service.get_latest_quote(symbol_code)
            if quote and "price" in quote:
                return Decimal(str(quote["price"]))
            return None

        except Exception as e:
            logger.error(f"Failed to fetch price for {symbol_code}: {str(e)}")
            return None

    def _calculate_price_change(
        self, price_at_create: Decimal, current_price: Decimal
    ) -> Decimal:
        """
        Calculate price change percentage.

        Args:
            price_at_create: Original price when prediction was created
            current_price: Current market price

        Returns:
            Price change percentage
        """
        if price_at_create == 0:
            return Decimal(0)

        change = ((current_price - price_at_create) / price_at_create) * 100
        return change.quantize(Decimal("0.01"))

    async def _determine_correct_option(
        self, prediction: dict, price_change_percent: Decimal
    ) -> Optional[str]:
        """
        Determine the correct option based on verification rules.

        Args:
            prediction: Prediction data
            price_change_percent: Calculated price change percentage

        Returns:
            Correct option key (A, B, C, or D) or None if unable to determine
        """
        verify_rule = prediction.get("verify_rule", "auto")

        if verify_rule == "manual":
            # Manual verification - admin needs to set correct answer
            logger.info("Manual verification required")
            return None

        # Auto verification based on conditions
        conditions = prediction.get("auto_verify_conditions", {})

        for option_key, condition_data in conditions.items():
            condition = condition_data.get("condition", "")

            # Evaluate condition
            # Example: "price_change_percent >= 1.0"
            if self._evaluate_condition(condition, price_change_percent):
                return option_key

        logger.warning("No matching condition found")
        return None

    def _evaluate_condition(self, condition: str, price_change: Decimal) -> bool:
        """
        Evaluate a verification condition.

        Args:
            condition: Condition string (e.g., "price_change_percent >= 1.0")
            price_change: Actual price change percentage

        Returns:
            True if condition is met
        """
        try:
            # Replace placeholder with actual value
            condition_str = condition.replace(
                "price_change_percent", str(price_change)
            )

            # Safely evaluate the condition
            # Note: In production, use a proper expression parser
            return eval(condition_str)

        except Exception as e:
            logger.error(f"Failed to evaluate condition '{condition}': {str(e)}")
            return False

    async def _update_prediction(
        self, prediction_id: str, current_price: Decimal, correct_option: str
    ) -> None:
        """
        Update prediction with verification results.

        Args:
            prediction_id: Prediction ID
            current_price: Price at verification time
            correct_option: Determined correct option
        """
        if not self.prediction_repository:
            return

        try:
            await self.prediction_repository.update(
                prediction_id,
                {
                    "price_at_verify": float(current_price),
                    "correct_option": correct_option,
                    "status": "ended",
                }
            )

        except Exception as e:
            logger.error(f"Failed to update prediction {prediction_id}: {str(e)}")

    async def _update_votes(self, prediction_id: str, correct_option: str) -> None:
        """
        Update all votes for this prediction with correctness flag.

        Args:
            prediction_id: Prediction ID
            correct_option: Correct option key
        """
        if not self.vote_repository:
            return

        try:
            # Update all votes for this prediction
            await self.vote_repository.update_correctness(
                prediction_id, correct_option
            )

        except Exception as e:
            logger.error(f"Failed to update votes for {prediction_id}: {str(e)}")

    async def _update_user_statistics(self, prediction_id: str) -> None:
        """
        Update prediction statistics for all users who voted.

        Args:
            prediction_id: Prediction ID
        """
        if not self.user_stats_repository or not self.vote_repository:
            return

        try:
            # Get all votes for this prediction
            votes = await self.vote_repository.find_by_prediction(prediction_id)

            for vote in votes:
                user_id = vote.get("user_id")
                is_correct = vote.get("is_correct", False)

                # Update user stats
                await self.user_stats_repository.update_after_verification(
                    user_id, is_correct
                )

        except Exception as e:
            logger.error(f"Failed to update user statistics: {str(e)}")

    async def _broadcast_verification(
        self, prediction: dict, correct_option: str, current_price: Decimal
    ) -> None:
        """
        Broadcast verification result via WebSocket.

        Args:
            prediction: Prediction data
            correct_option: Correct option key
            current_price: Price at verification
        """
        if not self.websocket_manager:
            return

        try:
            message = {
                "type": "prediction_verified",
                "payload": {
                    "prediction_id": prediction.get("id"),
                    "symbol_code": prediction.get("symbol_code"),
                    "correct_option": correct_option,
                    "price_at_verify": float(current_price),
                }
            }

            # Broadcast to all connected clients
            await self.websocket_manager.broadcast_all(message)

        except Exception as e:
            logger.error(f"Failed to broadcast verification: {str(e)}")

    async def _send_notifications(
        self, prediction: dict, correct_option: str
    ) -> None:
        """
        Send push notifications to all participants.

        Args:
            prediction: Prediction data
            correct_option: Correct option key
        """
        if not self.notification_service or not self.vote_repository:
            return

        try:
            prediction_id = prediction.get("id")
            question = prediction.get("question")

            # Get all users who voted
            votes = await self.vote_repository.find_by_prediction(prediction_id)

            for vote in votes:
                user_id = vote.get("user_id")
                user_vote = vote.get("selected_option")
                is_correct = vote.get("is_correct", False)

                # Prepare notification message
                result_text = "正确" if is_correct else "错误"
                message = f"预测结果已揭晓：{question} - 你的选择{user_vote}是{result_text}的！"

                # Send notification
                await self.notification_service.send_to_user(
                    user_id,
                    title="预测验证完成",
                    body=message,
                    data={
                        "type": "prediction_verified",
                        "prediction_id": prediction_id,
                        "is_correct": is_correct,
                    }
                )

        except Exception as e:
            logger.error(f"Failed to send notifications: {str(e)}")
