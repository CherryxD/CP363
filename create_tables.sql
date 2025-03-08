USE League_Database;

-- Leagues Table
CREATE TABLE Leagues (
    region CHAR(32) UNIQUE NOT NULL,
    PRIMARY KEY (region)
);

-- Teams Table
CREATE TABLE Teams (
    team_name CHAR(50) UNIQUE NOT NULL,
    short_name CHAR(4) UNIQUE NOT NULL,
    region CHAR(32) NOT NULL,
    PRIMARY KEY (short_name),
    FOREIGN KEY (region) REFERENCES Leagues(region)
);

-- Players Table
CREATE TABLE Players (
    user_name CHAR(50) UNIQUE NOT NULL,
    last_name CHAR(50) NOT NULL,
    first_name CHAR(50) NOT NULL,
    nationality CHAR(30) NOT NULL,
    birthdate DATE,
    team CHAR(4) NOT NULL,
    FOREIGN KEY (team) REFERENCES Teams(short_name),
    PRIMARY KEY (user_name)
);

-- Coaches Table
CREATE TABLE Coaches (
    user_name CHAR(50) UNIQUE NOT NULL,
    last_name CHAR(50) NOT NULL,
    first_name CHAR(50) NOT NULL,
    nationality CHAR(30) NOT NULL,
    birthdate DATE,
    team CHAR(4) NOT NULL,
    FOREIGN KEY (team) REFERENCES Teams(short_name),
    PRIMARY KEY (user_name)
);

-- Contracts Table
CREATE TABLE Contracts (
    contract_id INT NOT NULL AUTO_INCREMENT,
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (contract_id)
);

-- Transfers Table
CREATE TABLE Transfers (
    to_team CHAR(4) NOT NULL,
    from_team CHAR(4) NOT NULL,
    contract INT,
    date DATE,
    FOREIGN KEY (to_team) REFERENCES Teams(short_name),
    FOREIGN KEY (from_team) REFERENCES Teams(short_name)
);

-- Tournaments Table
CREATE TABLE Tournaments (
    tournament_name CHAR(32) NOT NULL,
    tier ENUM('A', 'B', 'C') NOT NULL,
    location CHAR(32) NOT NULL,
    PRIMARY KEY (tournament_name)
);

-- Matches Table
CREATE TABLE Matches (
    match_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    team1 CHAR(4),
    team2 CHAR(4),
    scheduled_date DATE NOT NULL,
    tournament CHAR(32) NOT NULL,
    PRIMARY KEY (match_id),
    FOREIGN KEY (tournament) REFERENCES Tournaments(tournament_name),
    FOREIGN KEY (team1) REFERENCES Teams(short_name),
    FOREIGN KEY (team2) REFERENCES Teams(short_name)
);

-- Results Table
CREATE TABLE Results (
    match_id INT NOT NULL,
    team1_score INT,
    team2_score INT,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);

-- Stats Table
CREATE TABLE Stats (
    user_name CHAR(50) NOT NULL,
    kills INT,
    deaths INT,
    assists INT,
    objectives INT,
    PRIMARY KEY (user_name),
    FOREIGN KEY (user_name) REFERENCES Players(user_name)
);

-- Awards Table
CREATE TABLE Awards (
    award_id INT NOT NULL AUTO_INCREMENT,
    award_name CHAR(50) NOT NULL,
    recipient_player CHAR(50),
    recipient_coach CHAR(50),
    date DATE,
    nominations SET('Nominee1', 'Nominee2', 'Nominee3'),
    PRIMARY KEY (award_id),
    FOREIGN KEY (recipient_player) REFERENCES Players(user_name),
    FOREIGN KEY (recipient_coach) REFERENCES Coaches(user_name),
    CHECK ((recipient_player IS NOT NULL and recipient_coach IS NULL) OR (recipient_player IS NULL and recipient_coach IS NOT NULL))
);
