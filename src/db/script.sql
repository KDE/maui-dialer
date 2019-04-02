CREATE TABLE IF NOT EXISTS CONTACTS (
id TEXT PRIMARY KEY,
photo TEXT,
n TEXT,
tel TEXT,
org TEXT,
email TEXT,
gender TEXT,
adr TEXT,
title TEXT,
account TEXT,
type TEXT,
fav INTEGER,
count INTEGER,
adddate DATE NOT NULL,
modified DATE NOT NULL
);
