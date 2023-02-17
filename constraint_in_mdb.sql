--1. Make sure that there is no duplicate movie
ALTER TABLE movie
ADD CONSTRAINT no_duplicate_fim UNIQUE(description);

--2. ràng buộc để không chồng chéo vé
ALTER TABLE ticket
ADD CONSTRAINT no_duplicate_ticket UNIQUE(screen_id, seat_id);

--3. 