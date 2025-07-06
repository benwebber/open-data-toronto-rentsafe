DROP TABLE IF EXISTS building;
CREATE TABLE building (
  -- Registration
  rsn TEXT PRIMARY KEY NOT NULL,
  type TEXT NOT NULL,
  address TEXT NOT NULL,
  postal_code_fsa TEXT NOT NULL,
  ward INTEGER NOT NULL,
  lat REAL NULL,
  lon REAL NULL,
  geometry AS (
    iif(
      lat IS NOT NULL AND lon IS NOT NULL,
      json_object(
        'type', 'Point',
        'coordinates', json_array(lon, lat)
      ),
      NULL
    )
  ),
  year_built INTEGER NOT NULL,
  year_registered INTEGER NOT NULL,
  storeys INTEGER NOT NULL,
  units INTEGER NOT NULL,
  management TEXT,
  -- Accessibility
  has_barrier_free_entrance INTEGER NULL,
  barrier_free_units INTEGER NULL,
  barrier_free_parking_spaces INTEGER NULL,
  -- Climate
  window_type TEXT NULL,
  heating_type TEXT NULL,
  heating_year_installed INTEGER NULL,
  cooling_type TEXT NULL,
  has_cooling_room INTEGER NULL,
  -- Elevators
  elevator INTEGER NOT NULL,
  elevator_status TEXT NULL,
  elevator_parts_replaced TEXT NULL,
  year_elevator_parts_replaced INTEGER NULL,
  date_elevators_last_inspected TEXT NULL,
  has_elevator_test_record INTEGER,
  -- Laundry
  has_laundry_room INTEGER NULL,
  laundry_room_hours TEXT,
  laundry_room_location TEXT,
  laundry_room_machines INTEGER NULL,
  -- Lifestyle
  is_non_smoking INTEGER NULL,
  has_balconies INTEGER NULL,
  has_storage INTEGER NULL,
  allows_pets INTEGER NULL,
  pet_restrictions TEXT NULL,
  amenities TEXT NOT NULL,
  description_child_play_area TEXT,
  description_indoor_exercise_room TEXT,
  description_outdoor_rec_facilities TEXT,
  -- Parking
  parking_types TEXT,
  visitor_parking TEXT,
  bicycle_parking TEXT,
  -- Safety
  has_intercom INTEGER NULL,
  has_fire_alarm INTEGER NULL,
  has_exterior_fire_escape INTEGER NULL,
  has_approved_fire_safety_plan INTEGER NULL,
  has_fire_alarm_test_record INTEGER NULL,
  has_fire_pump_flow_test_record INTEGER NULL,
  has_sprinkler_system INTEGER NULL,
  year_sprinkler_system_installed INTEGER NULL,
  has_sprinkler_system_test_record INTEGER NULL,
  has_emergency_power INTEGER NULL,
  has_emergency_power_test_record INTEGER NULL,
  -- Utilities
  has_per_unit_hydro_meters INTEGER NULL,
  has_per_unit_gas_meters INTEGER NULL,
  has_per_unit_water_meters INTEGER NULL,
  -- Waste
  waste_facilities TEXT,
  has_garbage_chutes INTEGER NULL,
  has_indoor_garbage_area INTEGER NULL,
  has_outdoor_garbage_area INTEGER NULL,
  recycling_location TEXT,
  green_bin_location TEXT
);
INSERT INTO building
SELECT
  -- Registration
  r.rsn,
  property_type,
  site_address,
  pcode,
  cast(r.ward AS INTEGER),
  nullif(e.latitude, ''),
  nullif(e.longitude, ''),
  year_built,
  year_registered,
  confirmed_storeys,
  confirmed_units,
  prop_management_company_name,
  -- Accessibility
  CASE barrier_free_accessibilty_entr WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  no_barrier_free_accessble_units,
  no_of_accessible_parking_spaces,
  -- Climate
  window_type,
  heating_type,
  heating_equipment_year_installed,
  air_conditioning_type,
  CASE is_there_a_cooling_room WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  -- Elevators
  no_of_elevators,
  nullif(elevator_status, ''),
  nullif(elevator_parts_replaced, ''),
  year_of_replacement,
  date_of_last_inspection_by_tssa,
  CASE tssa_test_records WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  -- Laundry
  CASE laundry_room WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  laundry_room_hours_of_operation,
  laundry_room_location,
  nullif(no_of_laundry_room_machines, ''),
  -- Lifestyle
  CASE non_smoking_building WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE balconies WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE locker_or_storage_room WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE pets_allowed WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  nullif(pet_restrictions, ''),
  amenities_available,
  description_of_child_play_area,
  description_of_indoor_exercise_room,
  description_of_outdoor_rec_facilities,
  -- Parking
  parking_type,
  visitor_parking,
  bike_parking,
  -- Safety
  CASE r.intercom WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE fire_alarm WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE exterior_fire_escape WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE approved_fire_safety_plan WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE annual_fire_alarm_test_records WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE annual_fire_pump_flow_test_records WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE sprinkler_system WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  nullif(sprinkler_system_year_installed, ''),
  CASE sprinkler_system_test_record WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE is_there_emergency_power WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE emerg_power_supply_test_records WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  -- Utilities
  CASE separate_hydro_meter_each_unit WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE separate_gas_meters_each_unit WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE separate_water_meters_ea_unit WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  -- Weste
  facilities_available,
  CASE garbage_chutes WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE indoor_garbage_storage_area WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  CASE outdoor_garbage_storage_area WHEN 'YES' THEN 1 WHEN 'NO' THEN 0 ELSE NULL END,
  recycling_bins_location,
  green_bin_location
FROM
  data.registration r
LEFT JOIN (
  SELECT
    *
  FROM
    data.evaluation
  GROUP BY
    rsn
  HAVING
    MAX("EVALUATION COMPLETED ON")
) e
ON
  r.rsn = e.rsn
;

DROP TABLE IF EXISTS building_fts;
CREATE VIRTUAL TABLE building_fts USING fts5 (address, management, content="building");
INSERT INTO building_fts (rowid, address, management) SELECT rowid, address, management FROM building;

DROP TABLE IF EXISTS main.evaluation;
CREATE TABLE main.evaluation (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  building_rsn TEXT NOT NULL,
  date TEXT NOT NULL,
  current_score INTEGER NOT NULL,
  proactive_score INTEGER NOT NULL,
  current_reactive_score INTEGER NOT NULL,
  areas_evaluated INTEGER NOT NULL,
  score_property_numbering INTEGER NULL,
  score_exterior_grounds INTEGER NULL,
  score_fencing INTEGER NULL,
  score_retaining_walls INTEGER NULL,
  score_drainage INTEGER NULL,
  score_building_ext INTEGER NULL,
  score_balcony_guards INTEGER NULL,
  score_windows INTEGER NULL,
  score_exterior_waste_area INTEGER NULL,
  score_exterior_walkways INTEGER NULL,
  score_clothing_drop_boxes INTEGER NULL,
  score_accessory_buildings INTEGER NULL,
  score_intercom INTEGER NULL,
  score_emergency_contact_sign INTEGER NULL,
  score_lobby_walls_and_ceiling INTEGER NULL,
  score_lobby_floors INTEGER NULL,
  score_laundry_room INTEGER NULL,
  score_interior_waste_area INTEGER NULL,
  score_mailboxes INTEGER NULL,
  score_exterior_doors INTEGER NULL,
  score_storage INTEGER NULL,
  score_pools INTEGER NULL,
  score_other_amenities INTEGER NULL,
  score_parking INTEGER NULL,
  score_abandoned_equipment INTEGER NULL,
  score_garbage_room INTEGER NULL,
  score_elevator_maintenance INTEGER NULL,
  score_elevator_cosmetics INTEGER NULL,
  score_interior_hallway_walls_and_ceiling INTEGER NULL,
  score_interior_hallway_floors INTEGER NULL,
  score_interior_lights INTEGER NULL,
  score_common_area_ventilation INTEGER NULL,
  score_electrical INTEGER NULL,
  score_chute_rooms INTEGER NULL,
  score_stairwell_walls_and_ceiling INTEGER NULL,
  score_stairwell_steps INTEGER NULL,
  score_stairwell_lighting INTEGER NULL,
  score_interior_handrail_guard_safety INTEGER NULL,
  score_interior_handrail_guard_maintenance INTEGER NULL,
  score_graffiti INTEGER NULL,
  score_cleanliness INTEGER NULL,
  score_common_area_pests INTEGER NULL,
  score_tenant_notification_board INTEGER NULL,
  score_pest_control_log INTEGER NULL,
  score_maintenance_log INTEGER NULL,
  score_cleaning_log INTEGER NULL,
  score_vital_service_plan INTEGER NULL,
  score_electrical_safety_plan INTEGER NULL,
  score_state_of_good_repair_plan INTEGER NULL,
  score_tenant_service_request_log INTEGER NULL,
  FOREIGN KEY (building_rsn) REFERENCES building (rsn)
);
INSERT INTO main.evaluation
SELECT
  NULL,
  rsn,
  nullif("EVALUATION COMPLETED ON", 'N/A'),
  nullif("CURRENT BUILDING EVAL SCORE", 'N/A'),
  nullif("PROACTIVE BUILDING SCORE", 'N/A'),
  nullif("CURRENT REACTIVE SCORE", 'N/A'),
  nullif("NO OF AREAS EVALUATED", 'N/A'),
  nullif("NUMBERING OF PROPERTY", 'N/A'),
  nullif("EXTERIOR GROUNDS", 'N/A'),
  nullif("FENCING", 'N/A'),
  nullif("RETAINING WALLS", 'N/A'),
  nullif("CATCH BASINS / STORM DRAINAGE", 'N/A'),
  nullif("BUILDING EXTERIOR", 'N/A'),
  nullif("BALCONY GUARDS", 'N/A'),
  nullif("WINDOWS", 'N/A'),
  nullif("EXT. RECEPTACLE STORAGE AREA", 'N/A'),
  nullif("EXTERIOR WALKWAYS", 'N/A'),
  nullif("CLOTHING DROP BOXES", 'N/A'),
  nullif("ACCESSORY BUILDINGS", 'N/A'),
  nullif("INTERCOM", 'N/A'),
  nullif("EMERGENCY CONTACT SIGN", 'N/A'),
  nullif("LOBBY - WALLS AND CEILING", 'N/A'),
  nullif("LOBBY FLOORS", 'N/A'),
  nullif("LAUNDRY ROOM", 'N/A'),
  nullif("INT. RECEPTACLE STORAGE AREA", 'N/A'),
  nullif("MAIL RECEPTACLES", 'N/A'),
  nullif("EXTERIOR DOORS", 'N/A'),
  nullif("STORAGE AREAS/LOCKERS MAINT.", 'N/A'),
  nullif("POOLS", 'N/A'),
  nullif("OTHER AMENITIES", 'N/A'),
  nullif("PARKING AREAS", 'N/A'),
  nullif("ABANDONED EQUIP./DERELICT VEH.", 'N/A'),
  nullif("GARBAGE/COMPACTOR ROOM", 'N/A'),
  nullif("ELEVATOR MAINTENANCE", 'N/A'),
  nullif("ELEVATOR COSMETICS", 'N/A'),
  nullif("INT. HALLWAY - WALLS / CEILING", 'N/A'),
  nullif("INTERIOR HALLWAY FLOORS", 'N/A'),
  nullif("INT. LOBBY / HALLWAY LIGHTING", 'N/A'),
  nullif("COMMON AREA VENTILATION", 'N/A'),
  nullif("ELECTRICAL SERVICES / OUTLETS", 'N/A'),
  nullif("CHUTE ROOMS - MAINTENANCE", 'N/A'),
  nullif("STAIRWELL - WALLS AND CEILING", 'N/A'),
  nullif("STAIRWELL - LANDING AND STEPS", 'N/A'),
  nullif("STAIRWELL LIGHTING", 'N/A'),
  nullif("INT. HANDRAIL / GUARD - SAFETY", 'N/A'),
  nullif("INT. HANDRAIL / GUARD - MAINT.", 'N/A'),
  nullif("GRAFFITI", 'N/A'),
  nullif("BUILDING CLEANLINESS", 'N/A'),
  nullif("COMMON AREA PESTS", 'N/A'),
  nullif("TENANT NOTIFICATION BOARD", 'N/A'),
  nullif("PEST CONTROL LOG", 'N/A'),
  nullif("MAINTENANCE LOG", 'N/A'),
  nullif("CLEANING LOG", 'N/A'),
  nullif("VITAL SERVICE PLAN", 'N/A'),
  nullif("ELECTRICAL SAFETY PLAN", 'N/A'),
  nullif("STATE OF GOOD REPAIR PLAN", 'N/A'),
  nullif("TENANT SERVICE REQUEST LOG", 'N/A')
FROM
  data.evaluation
;

DROP VIEW IF EXISTS building_accessibility;
CREATE VIEW building_accessibility AS
SELECT
  rsn,
  has_barrier_free_entrance,
  barrier_free_units,
  barrier_free_parking_spaces
FROM building;

DROP VIEW IF EXISTS building_climate;
CREATE VIEW building_climate AS
SELECT
  rsn,
  window_type,
  heating_type,
  heating_year_installed,
  cooling_type,
  has_cooling_room
FROM building;

DROP VIEW IF EXISTS building_elevator;
CREATE VIEW building_elevator AS
SELECT
  rsn,
  elevators,
  elevator_status,
  elevator_parts_replaced,
  year_elevator_parts_replaced,
  date_elevators_last_inspected,
  has_elevator_tssa_test_record
FROM building;

DROP VIEW IF EXISTS building_laundry;
CREATE VIEW building_laundry AS
SELECT
  rsn,
  has_laundry_room,
  laundry_room_hours,
  laundry_room_location,
  laundry_room_machines
FROM building;

DROP VIEW IF EXISTS building_lifestyle;
CREATE VIEW building_lifestyle AS
SELECT
  rsn,
  is_non_smoking,
  has_balconies,
  has_storage,
  allows_pets,
  pet_restrictions,
  amenities,
  description_child_play_area,
  description_indoor_exercise_room,
  description_outdoor_rec_facilities
FROM building;

DROP VIEW IF EXISTS building_parking;
CREATE VIEW building_parking AS
SELECT
  rsn,
  parking_types,
  visitor_parking,
  bicycle_parking
FROM building;

DROP VIEW IF EXISTS building_registration;
CREATE VIEW building_registration AS
SELECT
  rsn,
  type,
  address,
  postal_code_fsa,
  ward,
  lat,
  lon,
  geometry,
  year_built,
  year_registered,
  storeys,
  units,
  management
FROM building;

DROP VIEW IF EXISTS building_safety;
CREATE VIEW building_safety AS
SELECT
  rsn,
  has_intercom,
  has_fire_alarm,
  has_exterior_fire_escape,
  has_approved_fire_safety_plan,
  has_fire_alarm_test_record,
  has_fire_pump_flow_test_record,
  has_sprinkler_system,
  year_sprinkler_system_installed,
  has_sprinkler_system_test_record,
  has_emergency_power,
  has_emergency_power_test_record
FROM building;

DROP VIEW IF EXISTS building_utility;
CREATE VIEW building_utility AS
SELECT
  rsn,
  has_per_unit_hydro_meters,
  has_per_unit_gas_meters,
  has_per_unit_water_meters
FROM building;

DROP VIEW IF EXISTS building_waste;
CREATE VIEW building_waste AS
SELECT
  rsn,
  waste_facilities,
  has_garbage_chutes,
  has_indoor_garbage_area,
  has_outdoor_garbage_area,
  recycling_location,
  green_bin_location
FROM building;
