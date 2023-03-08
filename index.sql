-- Improve performance for client_get_seat_empty() and book_ticket()

CREATE INDEX idx_sr_screenid ON Screening USING HASH (screen_id);
CREATE INDEX idx_sr_roomid_n ON Screening (room_id);
CREATE INDEX idx_s_roomid_n ON Seat (room_id);

CREATE INDEX idx_s_seatid ON Seat USING HASH (seat_id);
CREATE INDEX idx_t_seatid ON Ticket USING HASH (seat_id);
