-- Reduce Imhotep to 1 charge
UPDATE GreatPersonIndividuals SET ActionCharges=1 WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP';

-- Fix Ibn Khaldun Bug
UPDATE ModifierArguments SET Value=4 WHERE Name='Amount' AND ModifierId IN
    ('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_SCIENCE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_CULTURE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_PRODUCTION',
    'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_GOLD', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_HAPPY_FAITH');
UPDATE ModifierArguments SET Value=8 WHERE Name='Amount' AND ModifierId IN
    ('GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_SCIENCE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_CULTURE', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_PRODUCTION',
    'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_GOLD', 'GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN_EMPIRE_ECSTATIC_FAITH');

-- Alfred Nobel grants one diplo point
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_GREATPERSON_1DIPLOPOINT', 'MODIFIER_PLAYER_ADJUST_DIPLOMATIC_VICTORY_POINTS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GREATPERSON_1DIPLOPOINT', 'Amount', '1');
INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL', 'BBG_GREATPERSON_1DIPLOPOINT', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

-- 21/08/22 Margaret Mead buff (2000 culture/science)
UPDATE ModifierArguments SET Value='2000' WHERE ModifierId='GREAT_PERSON_GRANT_LOTSO_SCIENCE' AND Name='Amount';
UPDATE ModifierArguments SET Value='2000' WHERE ModifierId='GREAT_PERSON_GRANT_LOTSO_CULTURE' AND Name='Amount';

-- 21/08/22 Mendeleev also gives 50% bonus prod towards labs

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_GREATPERSON_LAB_BOOST', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');

INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('BBG_GREATPERSON_LAB_BOOST', 'BuildingType', 'BUILDING_RESEARCH_LAB'),
	('BBG_GREATPERSON_LAB_BOOST', 'Amount', '50');

INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
    ('GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV', 'BBG_GREATPERSON_LAB_BOOST', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

--23/08/22 GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY

-- DELETE FROM GreatPersonIndividualActionModifiers WHERE ModifierId='';

-- INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
-- 	('BBG_GREATPERSON_')

--23/08/22 Turing also gives the tech if you already have eureka
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
	('BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'TechType', 'TECH_COMPUTERS'),
	('BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'GrantTechIfBoosted', '1');

DELETE FROM GreatPersonIndividualActionModifiers WHERE ModifierId='GREATPERSON_COMPUTERSTECHBOOST' AND GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_ALAN_TURING';

INSERT INTO GreatPersonIndividualActionModifiers (GreatPersonIndividualType, ModifierId, AttachmentTargetType) VALUES
	('GREAT_PERSON_INDIVIDUAL_ALAN_TURING', 'BBG_GREAT_PERSON_INDIVIDUAL_BOOST_OR_GRANT_COMPUTERS', 'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');