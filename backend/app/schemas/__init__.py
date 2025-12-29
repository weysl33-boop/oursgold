"""Pydantic schemas module"""

from app.schemas.user import (
    UserBase,
    UserCreate,
    UserUpdate,
    UserResponse,
    UserLogin,
    Token,
    TokenData,
)
from app.schemas.symbol import (
    SymbolBase,
    SymbolCreate,
    SymbolUpdate,
    SymbolResponse,
)
from app.schemas.quote import (
    QuoteBase,
    QuoteCreate,
    QuoteResponse,
    QuoteWithSymbol,
    HistoricalQuote,
    HistoricalQuoteResponse,
)
from app.schemas.comment import (
    CommentBase,
    CommentCreate,
    CommentUpdate,
    CommentResponse,
    CommentWithReplies,
    CommentLikeResponse,
    CommentListResponse,
)
from app.schemas.prediction import (
    PredictionOption,
    PredictionBase,
    PredictionCreate,
    PredictionUpdate,
    PredictionResponse,
    PredictionWithVotes,
    PredictionListResponse,
    VoteDistribution,
)
from app.schemas.vote import (
    VoteBase,
    VoteCreate,
    VoteResponse,
    VoteResultResponse,
)
from app.schemas.news import (
    NewsBase,
    NewsCreate,
    NewsUpdate,
    NewsResponse,
    NewsListItem,
    NewsListResponse,
)
from app.schemas.community import (
    HotTopic,
    TrendingSymbol,
    TopComment,
    UserPredictionStatsResponse,
    LeaderboardEntry,
    LeaderboardResponse,
    CommunityTopicsResponse,
    TrendingSymbolsResponse,
    TopCommentsResponse,
)

__all__ = [
    # User
    "UserBase",
    "UserCreate",
    "UserUpdate",
    "UserResponse",
    "UserLogin",
    "Token",
    "TokenData",
    # Symbol
    "SymbolBase",
    "SymbolCreate",
    "SymbolUpdate",
    "SymbolResponse",
    # Quote
    "QuoteBase",
    "QuoteCreate",
    "QuoteResponse",
    "QuoteWithSymbol",
    "HistoricalQuote",
    "HistoricalQuoteResponse",
    # Comment
    "CommentBase",
    "CommentCreate",
    "CommentUpdate",
    "CommentResponse",
    "CommentWithReplies",
    "CommentLikeResponse",
    "CommentListResponse",
    # Prediction
    "PredictionOption",
    "PredictionBase",
    "PredictionCreate",
    "PredictionUpdate",
    "PredictionResponse",
    "PredictionWithVotes",
    "PredictionListResponse",
    "VoteDistribution",
    # Vote
    "VoteBase",
    "VoteCreate",
    "VoteResponse",
    "VoteResultResponse",
    # News
    "NewsBase",
    "NewsCreate",
    "NewsUpdate",
    "NewsResponse",
    "NewsListItem",
    "NewsListResponse",
    # Community
    "HotTopic",
    "TrendingSymbol",
    "TopComment",
    "UserPredictionStatsResponse",
    "LeaderboardEntry",
    "LeaderboardResponse",
    "CommunityTopicsResponse",
    "TrendingSymbolsResponse",
    "TopCommentsResponse",
]
