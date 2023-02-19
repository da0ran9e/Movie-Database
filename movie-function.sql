-- CREATE OR REPLACE FUNCTION SearchMovieTitle(str_title text[])
-- RETURNS TABLE AS
-- $$
-- BEGIN
-- 	SELECT *
-- 	FROM Movies
-- 	WHERE title_tokens @@ plainto_tsquery(str_title)
-- END;
-- $$


-- UPDATE Movies M
-- SET title_tokens = to_tsvector(M.title)
-- WHERE title_tokens IS NULL;

-- --- Maybe phraseto_tsquery if we want to use <-> (FOLLOWED BY) instead of &	


