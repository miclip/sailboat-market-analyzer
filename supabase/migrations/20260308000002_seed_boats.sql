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
