-- Seed boat design data
INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('amel-super-maramu', 'Amel Super Maramu', 'Amel', 1989, 1999, 53, 14.8, 37500, 11000, 0.29, 43, 1140, 15.2, 'skeg_hung', 'modified_fin', 'keel_stepped', 'ketch', 'center', 'modified_full', NULL, 'moderate', 38.5, 1.72, 238, true, true, true, 'Purpose-built bluewater cruiser. Center cockpit, ketch rig. Known for robust systems and excellent passage-making ability.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('amel-super-maramu-2000', 'Amel Super Maramu 2000', 'Amel', 1999, 2007, 53, 14.8, 38000, 11200, 0.29, 43, 1140, 15.0, 'skeg_hung', 'modified_fin', 'keel_stepped', 'ketch', 'center', 'modified_full', NULL, 'moderate', 39.0, 1.71, 242, true, true, true, 'Updated version with improved electrical systems and interior. Same proven hull as original Super Maramu.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('amel-54', 'Amel 54', 'Amel', 2002, 2012, 54, 15.4, 41000, 12300, 0.30, 46, 1250, 15.4, 'skeg_hung', 'modified_fin', 'keel_stepped', 'ketch', 'center', 'modified_full', NULL, 'moderate', 40.2, 1.68, 240, true, true, true, 'Flagship Amel. Modern systems, larger interior, same bluewater DNA.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('valiant-40', 'Valiant 40', 'Valiant', 1973, 1990, 39.8, 12.1, 22000, 8800, 0.40, 33.5, 750, 15.9, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 32.8, 1.82, 288, true, false, false, 'Bob Perry design. One of the most respected bluewater cruisers ever built. Canoe stern, high ballast ratio.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('valiant-42', 'Valiant 42', 'Valiant', 1990, 2007, 42.2, 12.6, 24500, 10000, 0.41, 35.5, 820, 16.0, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 33.5, 1.80, 275, true, false, false, 'Evolution of the V-40. Center cockpit option available. Excellent passage maker.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('psc-37', 'Pacific Seacraft 37', 'Pacific Seacraft', 1977, 2003, 37.2, 10.9, 18500, 7200, 0.39, 29.3, 650, 15.6, 'skeg_hung', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 35.0, 1.75, 340, true, false, false, 'W.I.B. Crealock design. Gold standard for bluewater cruising in this size range. Full keel, bulletproof construction.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('psc-40', 'Pacific Seacraft 40', 'Pacific Seacraft', 1981, 2002, 40.0, 11.8, 22500, 8500, 0.38, 32.0, 740, 15.3, 'skeg_hung', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 36.5, 1.73, 330, true, false, false, 'Crealock design. Bigger sister to the PSC 37 with more interior volume. Outstanding build quality.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('ip-380', 'Island Packet 380', 'Island Packet', 1999, 2007, 38.3, 12.5, 21000, 8200, 0.39, 33.2, 700, 14.8, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 33.0, 1.86, 280, true, false, false, 'Full keel, high freeboard. Excellent liveaboard and coastal cruiser. Can handle offshore but not a speedster.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('ip-420', 'Island Packet 420', 'Island Packet', 2001, 2010, 42.0, 13.5, 25000, 10000, 0.40, 36.0, 810, 14.9, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 35.2, 1.81, 275, true, false, true, 'Island Packet''s sweet spot. Good blend of liveaboard space and offshore capability.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hc-33', 'Hans Christian 33', 'Hans Christian', 1978, 1992, 33.0, 10.5, 16500, 6600, 0.40, 26.3, 540, 14.5, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 34.0, 1.79, 370, true, false, false, 'Traditional double-ender. Heavy, slow, but extremely seaworthy. Beautiful teak interiors.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hc-38', 'Hans Christian 38', 'Hans Christian', 1980, 1994, 38.0, 11.5, 22000, 8800, 0.40, 30.5, 680, 14.8, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 37.0, 1.69, 350, true, false, false, 'Larger HC with center cockpit option. Traditional construction, proven offshore.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('cabo-rico-38', 'Cabo Rico 38', 'Cabo Rico', 1986, 2004, 38.0, 11.5, 20000, 8000, 0.40, 30.5, 690, 15.5, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'aft', 'modified_full', NULL, 'moderate', 34.5, 1.77, 310, true, false, false, 'W.I.B. Crealock design. Beautiful lines, excellent build quality. A refined bluewater cruiser.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hallberg-rassy-42', 'Hallberg-Rassy 42', 'Hallberg-Rassy', 1992, 2003, 42.0, 13.0, 24700, 9400, 0.38, 35.0, 850, 16.2, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'center', 'modified_full', NULL, 'moderate', 34.0, 1.78, 268, true, false, false, 'Swedish quality. Center cockpit, windshield. Great combination of comfort and offshore capability.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hallberg-rassy-46', 'Hallberg-Rassy 46', 'Hallberg-Rassy', 1996, 2006, 46.0, 13.5, 29000, 11000, 0.38, 38.5, 980, 16.3, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'center', 'modified_full', NULL, 'moderate', 35.8, 1.74, 260, true, false, true, 'Larger HR with more liveaboard space. Same build quality and offshore pedigree.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('oyster-46', 'Oyster 46', 'Oyster', 1998, 2008, 46.0, 14.0, 30000, 11500, 0.38, 39.0, 1010, 16.1, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'center', 'modified_full', NULL, 'moderate', 36.0, 1.73, 255, true, true, true, 'British luxury bluewater yacht. Center cockpit, excellent build quality. ARC rally proven.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('swan-44', 'Swan 44', 'Nautor Swan', 1986, 1998, 44.0, 13.2, 25500, 10500, 0.41, 35.0, 900, 16.8, 'spade', 'fin', 'keel_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 30.5, 1.82, 248, true, false, false, 'Performance-oriented bluewater yacht. Sparkman & Stephens design. Fast but capable offshore.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('tayana-37', 'Tayana 37', 'Tayana', 1978, 1996, 37.0, 11.3, 20500, 8000, 0.39, 30.5, 670, 14.9, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 35.0, 1.72, 335, true, false, false, 'Bob Harris design. Hugely popular bluewater cruiser. Double-ender, heavily built. Great value.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('tayana-42', 'Tayana 42', 'Tayana', 1985, 1998, 42.0, 12.8, 25000, 10000, 0.40, 35.0, 790, 15.1, 'skeg_hung', 'modified_fin', 'keel_stepped', 'cutter', 'center', 'modified_full', NULL, 'moderate', 35.5, 1.76, 285, true, false, false, 'Center cockpit bluewater cruiser. Excellent value for size and capability.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('hr-37', 'Hallberg-Rassy 37', 'Hallberg-Rassy', 1994, 2003, 37.0, 12.0, 18700, 7100, 0.38, 31.0, 680, 16.0, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 31.5, 1.85, 265, true, false, false, 'Compact HR with excellent fit and finish. Capable offshore cruiser in a manageable size.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('ip-440', 'Island Packet 440', 'Island Packet', 2004, 2012, 44.0, 13.8, 28000, 11200, 0.40, 37.5, 870, 14.7, 'full_keel_integrated', 'full', 'keel_stepped', 'cutter', 'aft', 'full_keel', NULL, 'deep', 37.5, 1.75, 280, true, false, true, 'Large Island Packet. Generous interior volume. Trades upwind performance for comfort and stability.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('wauquiez-pilot-saloon-43', 'Wauquiez Pilot Saloon 43', 'Wauquiez', 1998, 2006, 43.0, 13.6, 24000, 9200, 0.38, 36.5, 860, 16.5, 'skeg_hung', 'modified_fin', 'keel_stepped', 'sloop', 'aft', 'modified_full', NULL, 'moderate', 32.0, 1.84, 248, true, false, true, 'Raised saloon design with excellent visibility. Deck saloon makes for great liveaboard. Capable offshore.', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO boats (id, design_name, manufacturer, year_range_start, year_range_end, length_ft, beam_ft, displacement_lbs, ballast_lbs, ballast_ratio, lwl_ft, sail_area_sqft, sa_displacement_ratio, rudder_type, keel_type, mast_step, rig_type, cockpit_type, hull_type, underbody_pct, forefoot_depth, motion_comfort_ratio, capsize_screening_value, displacement_length_ratio, self_steering_compatible, watermaker_standard, generator_standard, notes, source_url)
VALUES
  ('beneteau-oceanis-390', 'Beneteau Oceanis 390', 'Beneteau', 1988, 1995, 39.0, 13.0, 16500, 5500, 0.33, 33.5, 730, 18.2, 'spade', 'fin', 'deck_stepped', 'sloop', 'aft', 'fin_keel', NULL, 'cut_away', 24.0, 2.15, 185, true, false, false, 'Production cruiser. Capable coastal cruiser but not ideal for extended offshore. Light displacement, fast in moderate conditions.', NULL)
ON CONFLICT (id) DO NOTHING;

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
