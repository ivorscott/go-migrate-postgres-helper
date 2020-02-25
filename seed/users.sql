INSERT INTO users (name, age, email) VALUES 
('Jack', 13, 'jack@testemail.com' ),
('Jill', 9, 'jill@testemail.com')
ON CONFLICT DO NOTHING;