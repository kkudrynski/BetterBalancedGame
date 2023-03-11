--==============================================================
--******                G O V E R N O R S                 ******
--==============================================================

--===========================Moksha=================--
--5.1.4 add free starting promo on monks, 2nd promo bugged in 5.1.3
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_UNIT_TYPE_IS_MONK', 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_UNIT_TYPE_IS_MONK', 'UnitType', 'UNIT_WARRIOR_MONK');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_TYPE_IS_MONK_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_TYPE_IS_MONK_REQSET', 'BBG_REQUIRES_UNIT_TYPE_IS_MONK');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('MOKSHA_MONK_FREE_PROMO', 'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE', 'BBG_UNIT_TYPE_IS_MONK_REQSET');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('MOKSHA_MONK_FREE_PROMO', 'Amount', '-1');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierID) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT', 'MOKSHA_MONK_FREE_PROMO');
-- delete moksha's scrapped abilities
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
-- 15% culture moved to moksha
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_BISHOP' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN' AND ModifierId='LIBRARIAN_CULTURE_YIELD_BONUS';
-- nerf bishop to +50% outgoing pressure
--UPDATE ModifierArguments SET Value='50' WHERE ModifierId='CARDINAL_BISHOP_PRESSURE' AND Name='Amount';
-- move Moksha's abilities
UPDATE GovernorPromotions SET Level=2, 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';
UPDATE GovernorPromotions SET Level=1, 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';
UPDATE GovernorPromotions SET Level=2, 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';
-- Curator moved to last moksha ability
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT'),
        ('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT');
-- Move +1 Culture to Moksha
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT' AND PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';

-- 2020/12/21 - Moved Moska Citadel fix from new_bbg_nfp_babylon.sql here (was 25)
-- Related to https://github.com/iElden/BetterBalancedGame/issues/48
UPDATE ModifierArguments SET Value=24 WHERE ModifierId='CARDINAL_CITADEL_OF_GOD_FAITH_FINISH_BUILDINGS' AND Name='BuildingProductionPercent';

--============================Pingala===================--
-- move Pingala's 100% GPP to first on left ability
UPDATE GovernorPromotions SET Level=1, 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS', 'GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN');
-- create Pingala's science from trade routes ability and apply to middle right ability
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
    VALUES
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'Domestic', '1'),
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'Amount', '3'),
        ('EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion)
    VALUES
        ('GOVERNOR_THE_EDUCATOR', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column', BaseAbility)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_DESCRIPTION', 2, 2, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'EDUCATOR_SCIENCE_FROM_DOMESTIC_TRADE_BBG');
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER'),
        ('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'GOVERNOR_PROMOTION_EDUCATOR_TRADE_BBG');
-- Pingala's double adajacency Promo
-- 11/12/22 from x2 to x3
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'MODIFIER_CITY_DISTRICTS_ADJUST_YIELD_MODIFIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'Amount', '200'),
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG', 'YieldType', 'YIELD_SCIENCE');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES
        ('GOVERNOR_THE_EDUCATOR', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column', BaseAbility)
    VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_DESCRIPTION', 2, 0, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_MODIFIER_BBG');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG', 'GOVERNOR_PROMOTION_EDUCATOR_GRANTS'),
        ('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'EDUCATOR_DOUBLE_CAMPUS_ADJ_BBG');

--===============================Victor
-- Victor combat bonus reduced to +3
UPDATE ModifierArguments SET Value='3' WHERE ModifierId='GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS' AND Name='Amount';


--==============================Magnus======================================
-- Magnus' Surplus Logistics gives +2 production in addition to the food
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType) VALUES
    ('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'Amount', '2'),
    ('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'Domestic', '1'),
    ('SURPLUS_LOGISTICS_TRADE_ROUTE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT OR IGNORE INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS', 'SURPLUS_LOGISTICS_TRADE_ROUTE_PROD');
-- Magnus' Surplus Logistics gives only +1 food (reverted)
--UPDATE ModifierArguments SET Value='1' WHERE ModifierId='SURPLUS_LOGISTICS_TRADE_ROUTE_FOOD' AND Name='Amount';
-- switch Magnus' level 2 promos
UPDATE GovernorPromotions SET 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';

--=======================================Magnus+Victor
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_DEFENDER' WHERE GovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_RESOURCE_MANAGER' WHERE GovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EMBRASURE';
INSERT OR IGNORE INTO GovernorPromotionPrereqs ( GovernorPromotionType, PrereqGovernorPromotion ) VALUES
    ( 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST' ),
    ( 'GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST' ),
    ( 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS' ),
    ( 'GOVERNOR_PROMOTION_EMBRASURE', 'GOVERNOR_PROMOTION_GARRISON_COMMANDER' ),
    ( 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'GOVERNOR_PROMOTION_DEFENSE_LOGISTICS' ),
    ( 'GOVERNOR_PROMOTION_AIR_DEFENSE_INITIATIVE', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER' );
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';
UPDATE GovernorPromotions SET 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EMBRASURE';
UPDATE GovernorPromotions SET 'Column'=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotions SET 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AIR_DEFENSE_INITIATIVE';

--=================================Amani==========================================
-- Amani Abuse Fix... can immediately re-declare war when an enemy suzerian removes Amani
UPDATE GlobalParameters SET Value='1' WHERE Name='DIPLOMACY_PEACE_MIN_TURNS';
-- new 1st on left promo for Amani
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_AMBASSADOR', 'GOVERNOR_PROMOTION_NEGOTIATOR_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_NAME', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_DESCRIPTION', 1, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH'),
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENSE_LOGISTICS_SIEGE_PROTECTION');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');
-- move Amani's Emissary to 2nd on left
UPDATE GovernorPromotions SET Level=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER' WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_NEGOTIATOR_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
        ('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY', 'PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES');
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES' AND Name='Amount';
-- Delete Amani's Foreign Investor
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';


--Amani Traders
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQ', 'REQUIREMENT_PLOT_PROPERTY_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ', 'PropertyName', 'AMANI_ESTABLISHED_CS'),
    ('PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ', 'PropertyMinimum', '1'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQ', 'PropertyName', 'TRADER_TO_AMANI_CS'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQ', 'PropertyMinimum', '1');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG', 'PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG', 'CITY_HAS_OWN_AMANI_TRADEROUT_REQ');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG'),
    ('CS_AMANI_GIVES_2_PROD_MODIFIER_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG', 'YieldType', 'YIELD_FOOD'),
    ('CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG', 'Amount', 2),
    ('CS_AMANI_GIVES_2_PROD_MODIFIER_BBG', 'YieldType', 'YIELD_PRODUCTION'),
    ('CS_AMANI_GIVES_2_PROD_MODIFIER_BBG', 'Amount', 2);    
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_MAJOR_CIV', 'CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG'),
    ('TRAIT_LEADER_MAJOR_CIV', 'CS_AMANI_GIVES_2_PROD_MODIFIER_BBG');


-- ====================================Liang=======================================
-- +1 prod on every resource
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('ZONING_COMMISH_PROD_CITIZEN_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'ZONING_COMMISH_PROD_BBG_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments ( ModifierId, Name, Value ) VALUES
    ( 'ZONING_COMMISH_PROD_CITIZEN_BBG', 'Amount', '1' ),
    ( 'ZONING_COMMISH_PROD_CITIZEN_BBG', 'YieldType', 'YIELD_PRODUCTION' );
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('ZONING_COMMISH_PROD_BBG_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('ZONING_COMMISH_PROD_BBG_REQUIREMENTS', 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
UPDATE GovernorPromotionModifiers SET ModifierId='ZONING_COMMISH_PROD_CITIZEN_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER' AND ModifierId='ZONING_COMMISSIONER_FASTER_DISTRICT_CONSTRUCTION';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER';
INSERT OR IGNORE INTO GovernorPromotionPrereqs ( GovernorPromotionType, PrereqGovernorPromotion ) VALUES
    ( 'GOVERNOR_PROMOTION_ZONING_COMMISSIONER', 'GOVERNOR_PROMOTION_PARKS_RECREATION' );
    --( 'GOVERNOR_PROMOTION_ZONING_COMMISSIONER', 'GOVERNOR_PROMOTION_WATER_WORKS' );
UPDATE GovernorPromotions SET Level=3, 'Column'=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_ZONING_COMMISSIONER';

-- +1 food on every resource
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AQUACULTURE';
DELETE FROM Types WHERE Type='GOVERNOR_PROMOTION_AQUACULTURE';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('AGRICULTURE_FOOD_BBG', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'AGRICULTURE_FOOD_BBG_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AGRICULTURE_FOOD_BBG', 'YieldType', 'YIELD_FOOD');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('AGRICULTURE_FOOD_BBG', 'Amount', '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES ('AGRICULTURE_FOOD_BBG_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES ('AGRICULTURE_FOOD_BBG_REQUIREMENTS', 'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('AGRICULTURE_PROMOTION_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_BUILDER', 'AGRICULTURE_PROMOTION_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES ('AGRICULTURE_PROMOTION_BBG', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_NAME', 'LOC_GOVERNOR_PROMOTION_AGRICULTURE_DESCRIPTION', 1, 2);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES ('AGRICULTURE_PROMOTION_BBG', 'AGRICULTURE_FOOD_BBG');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES ('AGRICULTURE_PROMOTION_BBG', 'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER');

-- better parks
UPDATE Improvement_YieldChanges SET YieldChange=3 WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND YieldType='YIELD_CULTURE';
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_CITY_PARK', 'YIELD_SCIENCE', 3);
INSERT OR IGNORE INTO Improvement_YieldChanges (ImprovementType, YieldType, YieldChange) VALUES
    ('IMPROVEMENT_CITY_PARK', 'YIELD_GOLD', 3);
UPDATE Modifiers SET SubjectRequirementSetId=NULL WHERE ModifierId='CITY_PARK_WATER_AMENITY';
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('CITY_PARK_HOUSING_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('CITY_PARK_HOUSING_BBG', 'Amount', '1');
INSERT OR IGNORE INTO ImprovementModifiers (ImprovementType, ModifierID) VALUES
    ('IMPROVEMENT_CITY_PARK', 'CITY_PARK_HOUSING_BBG');
DELETE FROM ImprovementModifiers WHERE ModifierID='CITY_PARK_GOVERNOR_CULTURE';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_DESERT_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_GRASS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_PLAINS_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_SNOW_HILLS';
DELETE FROM Improvement_ValidTerrains WHERE ImprovementType='IMPROVEMENT_CITY_PARK' AND TerrainType='TERRAIN_TUNDRA_HILLS';
UPDATE Improvements SET OnePerCity=1 WHERE ImprovementType='IMPROVEMENT_CITY_PARK';
-- move parks
UPDATE GovernorPromotions SET Level=2, 'Column'=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_PARKS_RECREATION';

-- add fishery to tech tree
UPDATE Improvements SET TraitType=NULL WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM ImprovementModifiers WHERE ImprovementType='IMPROVEMENT_FISHERY';
DELETE FROM Modifiers WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
DELETE FROM ModifierArguments WHERE ModifierId='AQUACULTURE_CAN_BUILD_FISHERY';
UPDATE Improvements SET PrereqTech='TECH_CARTOGRAPHY' WHERE ImprovementType='IMPROVEMENT_FISHERY';

-- 07/12 Liang 3 turns
UPDATE Governors SET TransitionStrength=150 WHERE GovernorType='GOVERNOR_THE_BUILDER';

--=============================Reyna=================================
-- Reyna's new 3rd level right ability
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('MANAGER_BUILDING_GOLD_DISCOUNT_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_BUILDINGS_PURCHASE_COST'),
    ('MANAGER_DISTRICT_GOLD_DISCOUNT_BBG', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_DISTRICTS_PURCHASE_COST');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('MANAGER_BUILDING_GOLD_DISCOUNT_BBG', 'Amount', '50'),
    ('MANAGER_DISTRICT_GOLD_DISCOUNT_BBG', 'Amount', '50');
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_MANAGER_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_MERCHANT', 'GOVERNOR_PROMOTION_MANAGER_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_NAME', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_DESCRIPTION', 3, 2);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'MANAGER_BUILDING_GOLD_DISCOUNT_BBG'),
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'MANAGER_DISTRICT_GOLD_DISCOUNT_BBG');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_MANAGER_BBG', 'GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR');
-- Delete Reyna's old one
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
-- bump gold from base ability
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='FOREIGN_EXCHANGE_GOLD_FROM_FOREIGN_TRADE_PASSING_THROUGH' AND Name='Amount';
-- add +2 gold per breathtaking
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_BBG', 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_BBG', 'RequirementSetId', 'PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS');
INSERT OR IGNORE INTO RequirementSets VALUES
    ('PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG', 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements VALUES
    ('PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG', 'REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_BBG'),
    ('PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG', 'REQUIRES_PLOT_BREATHTAKING_APPEAL');
UPDATE Modifiers SET SubjectRequirementSetId='PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_BBG' WHERE ModifierId='FORESTRY_MANAGEMENT_FEATURE_NO_IMPROVEMENT_GOLD';
-- +1 trade route
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TAX_COLLECTOR_ADJUST_TRADE_CAPACITY_BBG', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TAX_COLLECTOR_ADJUST_TRADE_CAPACITY_BBG', 'Amount', '1');
INSERT OR IGNORE INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR', 'TAX_COLLECTOR_ADJUST_TRADE_CAPACITY_BBG');