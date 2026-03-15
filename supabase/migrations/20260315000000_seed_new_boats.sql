-- Seed new boat designs added 2026-03-15
-- Little Harbor
INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('little-harbor-38', 'Little Harbor 38', 'Little Harbor', 1982, 1988, 38.0, 11.83, 20600, 8400, 0.41, 31.0, 739, 15.8, 'spade', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 35.81, 1.73, 309, true, false, false, 'Ted Hood design. 31 hulls built by Lien Hwa. Centerboard with lead ballast for shoal-draft versatility. Excellent build quality and seakeeping.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('little-harbor-44', 'Little Harbor 44', 'Little Harbor', 1983, 1987, 44.33, 13.67, 32500, 13800, 0.42, 36.5, 937, 14.78, 'spade', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 39.72, 1.72, 298, true, false, false, 'Ted Hood design. 15 hulls built. High ballast ratio (42.5%) and centerboard for exceptional stability and shoal-draft access.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('little-harbor-46', 'Little Harbor 46', 'Little Harbor', 1986, 1992, 45.67, 13.75, 32500, 13800, 0.42, 36.5, 966, 15.24, 'spade', 'centerboard', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 39.01, 1.73, 298, true, false, false, 'Ted Hood design. 21 hulls built. Cutter rig for bluewater versatility. Centerboard — 5ft board up, 10ft board down.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('little-harbor-50', 'Little Harbor 50', 'Little Harbor', 1982, NULL, 50.75, 15.08, 43200, 18000, 0.42, 42.17, 1250, 16.32, 'spade', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 40.23, 1.72, 257, true, false, true, 'Ted Hood design. Semi-custom bluewater cruiser. Centerboard — 5.5ft board up, 11.5ft board down. 330 gallon water capacity.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('little-harbor-54', 'Little Harbor 54', 'Little Harbor', 1989, NULL, 54.0, 15.0, 62359, 19000, 0.30, 43.17, 1272, 13.0, 'spade', 'centerboard', 'keel_stepped', 'sloop', 'center', 'modified_full', NULL, 'moderate', 56.38, 1.52, 346, true, true, true, 'Ted Hood design. Flagship heavy-displacement bluewater cruiser. Exceptional motion comfort (56.4) and capsize screening (1.52). Center cockpit.', NULL)
ON CONFLICT (id) DO NOTHING;

-- Alden
INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('alden-44', 'Alden 44', 'Alden', 1976, 1991, 44.16, 12.5, 24500, 10000, 0.41, 34.08, 871, 16.59, 'skeg_hung', 'centerboard', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 35.31, 1.72, 276, true, false, false, 'Alden Associates / Nils Helleberg design. 40 hulls built by Tillotson Pearson. Centerboard cutter — 4.9ft board up, 8.75ft board down.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('alden-44-mkii', 'Alden 44 MkII', 'Alden', 1981, NULL, 44.16, 12.46, 24500, 10000, 0.41, 34.92, 871, 16.59, 'skeg_hung', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 34.91, 1.72, 257, true, false, false, 'Updated Alden 44 with modified rudder/skeg, repositioned propeller shaft, and revised interior. Sloop rig replaces original cutter.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('alden-46', 'Alden 46', 'Alden', 1987, 1997, 47.67, 13.5, 32000, 13000, 0.41, 37.08, 1076, 17.15, 'skeg_hung', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 38.38, 1.70, 280, true, false, false, 'Niels Helleberg design. Centerboard — 5.3ft board up, 10.1ft board down. High ballast ratio with good SA/D balance.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('alden-50', 'Alden 50', 'Alden', 1996, 1998, 50.33, 13.5, 38000, 16300, 0.43, 37.08, 1092, 15.52, 'skeg_hung', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 44.68, 1.61, 333, true, false, false, 'Alden Yachts design. Only 3 built. Highest ballast ratio in the Alden line. Excellent comfort ratio (44.7).', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('alden-54', 'Alden 54', 'Alden', 1985, 2002, 54.08, 14.33, 36500, 15000, 0.41, 40.0, 1221, 17.83, 'skeg_hung', 'centerboard', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 36.81, 1.73, 255, true, false, false, 'Alden design. Cutter rig with best SA/D in the line (17.83). Long production run 1985-2002.', NULL)
ON CONFLICT (id) DO NOTHING;

-- Hylas, Bristol, Shannon, Outbound, Westsail, Mason, Passport, Hinckley, Tartan, Contest, Bowman, Morris
INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hylas-44', 'Hylas 44', 'Hylas', 1984, 1993, 44.17, 13.5, 22320, 11020, 0.49, 34.87, 866, 17.55, 'skeg_hung', 'fin', 'keel_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'moderate', 28.61, 1.92, 235, true, false, false, 'German Frers design. Built by Queen Long Marine (Taiwan). Exceptional ballast ratio (49.4%).', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('bristol-45-5', 'Bristol 45.5', 'Bristol', 1979, 1989, 45.25, 13.16, 34660, 15000, 0.43, 37.25, 988, 14.93, 'spade', 'centerboard', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 43.66, 1.62, 299, true, false, false, 'Ted Hood design. Centerboard — 4.9ft board up, 11ft board down. Same DNA as Little Harbor line.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('shannon-43', 'Shannon 43', 'Shannon', 1986, NULL, 43.83, 13.0, 27000, 10000, 0.37, 36.58, 910, 16.24, 'skeg_hung', 'centerboard', 'keel_stepped', 'ketch', 'aft', 'modified_full', NULL, 'moderate', 35.37, 1.74, 246, true, false, false, 'Walter Schultz design. Staysail ketch with centerboard. Built in USA by Shannon Yachts.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('shannon-38', 'Shannon 38', 'Shannon', 1975, 1988, 37.75, 11.5, 18500, 6500, 0.35, 30.83, 703, 16.14, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 33.59, 1.74, 282, true, false, false, 'Stadel / Schultz design. 100 hulls built. Long keel cutter. Built in USA by Shannon Yachts.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('outbound-44-46', 'Outbound 44/46', 'Outbound', 2001, NULL, 44.75, 13.5, 28000, 10000, 0.36, 40.25, 1083, 18.87, 'spade', 'fin', 'keel_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 32.49, 1.78, 192, true, false, false, 'Carl Schumacher design. 50 built. Modern fast bluewater cruiser — highest SA/D in class.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('westsail-32', 'Westsail 32', 'Westsail', 1971, 1981, 32.0, 11.0, 19500, 7000, 0.36, 27.5, 753, 16.69, 'transom_hung', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 42.85, 1.64, 419, true, false, false, 'Crealock / Atkin design. 834 hulls built. Iconic small bluewater cruiser. Full keel, canoe stern.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('mason-44', 'Mason 44', 'Mason', 1985, NULL, 43.92, 12.25, 27400, 9400, 0.34, 31.75, 921, 16.28, 'full_keel_integrated', 'full', 'keel_stepped', 'ketch', 'aft', 'full_keel', NULL, 'deep', 42.52, 1.63, 382, true, false, false, 'Al Mason / Jeff Leishman design. Built by Ta Shing (Taiwan). Long keel, canoe stern ketch.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('passport-40', 'Passport 40', 'Passport', 1980, 1991, 39.42, 12.67, 22771, 8500, 0.37, 33.42, 762, 15.24, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 33.96, 1.79, 272, true, false, false, 'Robert Perry design. 148 hulls built (Taiwan). Fin keel with skeg-hung rudder.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('passport-42', 'Passport 42', 'Passport', 1981, 1988, 42.0, 12.83, 25500, 9000, 0.35, 34.83, 764, 14.17, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 35.62, 1.75, 269, true, false, false, 'Stan Huntingford design. 50 hulls built (Taiwan). Cutter rig with skeg-hung rudder.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hinckley-bermuda-40', 'Hinckley Bermuda 40', 'Hinckley', 1971, NULL, 40.0, 11.75, 20000, 6500, 0.33, 28.83, 681, 14.84, 'skeg_hung', 'centerboard', 'keel_stepped', 'yawl', 'aft', 'modified_full', NULL, 'moderate', 36.09, 1.73, 373, true, false, false, 'William Tripp Jr. design. Built by Hinckley (Maine). Yawl rig with centerboard.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('tartan-3700', 'Tartan 3700', 'Tartan', 1999, NULL, 37.0, 12.66, 15950, 6000, 0.38, 32.5, 728, 18.44, 'spade', 'fin', 'keel_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 24.78, 2.02, 207, true, false, false, 'Tim Jackett design. Modern performance cruiser. Also available as keel/CB and shoal keel.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('tartan-42', 'Tartan 42', 'Tartan', 1980, 1984, 42.0, 12.25, 22000, 9000, 0.41, 32.0, 758, 15.51, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 34.53, 1.75, 300, true, false, false, 'Sparkman & Stephens design. 34 hulls built. High ballast ratio (40.9%).', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('contest-42s', 'Contest 42S', 'Contest', 1998, 2002, 41.17, 12.8, 29024, 11078, 0.38, 34.45, 962, 16.37, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 41.24, 1.67, 317, true, false, true, 'Dick Zaal design. 9 built by Conyplex (Netherlands). Dutch quality bluewater cruiser.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('contest-46', 'Contest 46', 'Contest', 1987, 1996, 46.42, 13.75, 33960, 13668, 0.40, 38.92, NULL, NULL, NULL, 'wing', 'keel_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'moderate', 38.86, 1.70, 257, true, false, true, 'Dick Zaal design. 55 built by Conyplex (Netherlands). Wing keel, high ballast ratio (40.3%).', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('bowman-40', 'Bowman 40', 'Bowman', 1987, NULL, 39.92, 12.58, 19000, NULL, NULL, 32.0, 743, 16.76, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 29.31, 1.89, 259, true, false, false, 'Chuck Paine design. 60 built by Southern Boat Building (UK). Shoal keel cutter (4.9ft draft).', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('bowman-42', 'Bowman 42', 'Bowman', 1998, NULL, 43.08, 12.58, 21429, 6800, 0.32, 32.75, 894, 18.61, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 31.70, 1.82, 272, true, false, false, 'Chuck Paine design. Built by Bowman / Rustler Yachts (UK). Cutter rig with skeg-hung rudder.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('morris-46', 'Morris 46', 'Morris', 1994, 2007, 45.92, 13.0, 23500, 8630, 0.37, 34.5, 879, 17.21, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'moderate', 31.45, 1.82, 255, true, false, false, 'Chuck Paine design. 14 built by Morris Yachts (Maine). Premium semi-custom build.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('morris-40', 'Morris 40', 'Morris', 1995, NULL, 40.92, 12.58, 19400, NULL, NULL, 32.0, 757, 16.84, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 29.67, 1.88, 264, true, false, false, 'Chuck Paine design. Built by Morris Yachts (Maine). Cutter rig, shallow draft (5.25ft).', NULL)
ON CONFLICT (id) DO NOTHING;

-- Modern production boats
INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('beneteau-oceanis-45', 'Beneteau Oceanis 45', 'Beneteau', 2013, NULL, 45.42, 14.75, 21048, NULL, NULL, 42.0, 1076, 22.67, 'spade', 'bulb_fin', 'deck_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 20.99, 2.14, 127, true, false, false, 'Finot-Conq / Nauta Design. High-volume French production cruiser. Very light displacement, fast but not comfortable offshore.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('jeanneau-sun-odyssey-44i', 'Jeanneau Sun Odyssey 44i', 'Jeanneau', 2009, NULL, 45.11, 14.34, 21892, 6512, 0.30, 37.57, 1082, 22.21, 'spade', 'bulb_fin', 'deck_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 24.49, 2.05, 184, true, false, false, 'Philippe Briand design. French production cruiser. Low ballast ratio (29.8%). Wide beam for interior volume.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hanse-445', 'Hanse 445', 'Hanse', 2010, NULL, 44.36, 14.37, 24251, 7716, 0.32, 40.03, 1021, 19.58, 'spade', 'bulb_fin', 'deck_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 26.07, 1.99, 169, true, false, false, 'Judel/Vrolijk design. German production cruiser. Self-tacking jib option.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('dufour-460-grand-large', 'Dufour 460 Grand Large', 'Dufour', 2016, NULL, 46.42, 14.76, 23721, 6283, 0.26, 41.14, 1073, 20.88, 'spade', 'bulb_fin', 'deck_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 23.80, 2.06, 152, true, false, false, 'Umberto Felci design. French production cruiser. Lowest ballast ratio in the fleet (26.5%).', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('bavaria-cruiser-46', 'Bavaria Cruiser 46', 'Bavaria', 2014, NULL, 46.82, 14.27, 27778, 7694, 0.28, 42.45, 1162, 20.35, 'spade', 'bulb_fin', 'deck_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 28.47, 1.89, 162, true, false, false, 'Farr Yacht Design. German production cruiser. Dual rudders, cast iron ballast.', NULL)
ON CONFLICT (id) DO NOTHING;
