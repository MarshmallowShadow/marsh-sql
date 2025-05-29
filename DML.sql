-- Insert Users
INSERT INTO `t_user` (`username`, `email`, `password`, `register_user`, `update_user`)
VALUES 
  ('alice', 'alice@example.com', '', 'system', 'system'),
  ('bob',   'bob@example.com',   '', 'system', 'system');

-- Insert Admins
INSERT INTO `t_admin` (`username`, `email`, `password`, `role`, `register_user`, `update_user`)
VALUES 
  ('admin1', 'admin1@example.com', '', 'super',     'system', 'system'),
  ('mod1',   'mod1@example.com',   '',   'moderator', 'system', 'system');
