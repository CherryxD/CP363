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
    transfer_id INT AUTO_INCREMENT,
    transfer_date DATE NOT NULL,
    PRIMARY KEY (transfer_id),
    FOREIGN KEY (to_team) REFERENCES Teams(short_name),
    FOREIGN KEY (from_team) REFERENCES Teams(short_name)
);

-- Transfer IDs Table
CREATE TABLE Transfer_Ids (
	transfer_id INT NOT NULL,
    contract_id INT NOT NULL,
    PRIMARY KEY (transfer_id, contract_id),
    FOREIGN KEY (transfer_id) REFERENCES Transfers(transfer_id) ON DELETE CASCADE,
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id) ON DELETE CASCADE
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
    PRIMARY KEY (match_id),
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
	received_date DATE NOT NULL,
	PRIMARY KEY (award_id)
);

-- Player Award Recipients Table
CREATE TABLE Player_Award_Recipients (
	award_id INT PRIMARY KEY,
	recipient_id CHAR(50) NOT NULL,
	FOREIGN KEY (award_id) REFERENCES Awards(award_id),
	FOREIGN KEY (recipient_id) REFERENCES Players(user_name)
);

-- Coach Award Recipients Table
CREATE TABLE Coach_Award_Recipients (
	award_id INT PRIMARY KEY,
	recipient_id CHAR(50) NOT NULL,
	FOREIGN KEY (award_id) REFERENCES Awards(award_id),
	FOREIGN KEY (recipient_id) REFERENCES Coaches(user_name)
);

-- Player Award Nominations
CREATE TABLE Player_Award_Nominations (
	award_id INT NOT NULL,
	nominee_id CHAR(50) NOT NULL,
	nominee_rank ENUM('First', 'Second', 'Third') NOT NULL,
	PRIMARY KEY (award_id, nominee_id),
	FOREIGN KEY (award_id) REFERENCES Awards(award_id) ON DELETE CASCADE,
	FOREIGN KEY (nominee_id) REFERENCES Players(user_name)
);


-- Coach Award Nominations
CREATE TABLE Coach_Award_Nominations (
	award_id INT NOT NULL,
	nominee_id CHAR(50) NOT NULL,
	nominee_rank ENUM('First', 'Second', 'Third') NOT NULL,
	PRIMARY KEY (award_id, nominee_id),
	FOREIGN KEY (award_id) REFERENCES Awards(award_id) ON DELETE CASCADE,
	FOREIGN KEY (nominee_id) REFERENCES Coaches(user_name)
);