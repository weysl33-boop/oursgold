-- Seed default symbols
INSERT INTO symbols (code, name_cn, name_en, market, symbol_type, base_currency, quote_currency, decimal_places, unit, description, is_active) VALUES
('XAUUSD', '伦敦金', 'Spot Gold', 'LBMA', 'gold', 'XAU', 'USD', 2, '盎司', 'London Bullion Market Association spot gold price in USD per troy ounce', TRUE),
('XAGUSD', '伦敦银', 'Spot Silver', 'LBMA', 'silver', 'XAG', 'USD', 3, '盎司', 'London Bullion Market Association spot silver price in USD per troy ounce', TRUE),
('EURUSD', '欧元/美元', 'EUR/USD', 'FOREX', 'currency', 'EUR', 'USD', 5, NULL, 'Euro vs US Dollar exchange rate', TRUE),
('GBPUSD', '英镑/美元', 'GBP/USD', 'FOREX', 'currency', 'GBP', 'USD', 5, NULL, 'British Pound vs US Dollar exchange rate', TRUE),
('USDJPY', '美元/日元', 'USD/JPY', 'FOREX', 'currency', 'USD', 'JPY', 3, NULL, 'US Dollar vs Japanese Yen exchange rate', TRUE),
('USDCNY', '美元/人民币', 'USD/CNY', 'FOREX', 'currency', 'USD', 'CNY', 4, NULL, 'US Dollar vs Chinese Yuan exchange rate', TRUE),
('AU9999', '上金所黄金9999', 'SGE Gold 9999', 'SGE', 'gold', NULL, 'CNY', 2, '克', 'Shanghai Gold Exchange 99.99% pure gold price in CNY per gram', TRUE),
('AU9995', '上金所黄金9995', 'SGE Gold 9995', 'SGE', 'gold', NULL, 'CNY', 2, '克', 'Shanghai Gold Exchange 99.95% pure gold price in CNY per gram', TRUE)
ON CONFLICT (code) DO NOTHING;
