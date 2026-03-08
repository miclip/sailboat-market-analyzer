import type { PromptInputs } from './types';
import { formatLabel, formatNumber } from './utils';

export function buildPrompt(inputs: PromptInputs): string {
	const { boat, scores, listing, use_case_primary, experience_level, target_waters } = inputs;

	const lines: string[] = [
		'You are evaluating a bluewater sailing vessel for offshore passage-making suitability.',
		'',
		'## Vessel Design',
		`Design: ${boat.design_name} (${boat.year_range_start ?? '?'}–${boat.year_range_end ?? '?'})`,
		`LOA: ${boat.length_ft ?? '?'}ft | Displacement: ${boat.displacement_lbs ? formatNumber(boat.displacement_lbs) + 'lbs' : '?'}`,
		`Ballast Ratio: ${boat.ballast_ratio ? (boat.ballast_ratio * 100).toFixed(0) + '%' : '?'} | D/L Ratio: ${boat.displacement_length_ratio?.toFixed(0) ?? '?'}`,
		`Capsize Screening Value: ${boat.capsize_screening_value?.toFixed(2) ?? '?'}`,
		`Motion Comfort Ratio: ${boat.motion_comfort_ratio?.toFixed(1) ?? '?'}`,
		'',
		'## Structural Characteristics',
		`Rudder: ${boat.rudder_type ? formatLabel(boat.rudder_type) : '?'}`,
		`Keel: ${boat.keel_type ? formatLabel(boat.keel_type) : '?'}`,
		`Mast Step: ${boat.mast_step ? formatLabel(boat.mast_step) : '?'}`,
		`Rig: ${boat.rig_type ? formatLabel(boat.rig_type) : '?'}`,
		`Cockpit: ${boat.cockpit_type ? formatLabel(boat.cockpit_type) : '?'}`,
		'',
		'## Use-Case Scores (0-100)',
		`Coastal Cruising: ${scores.score_coastal_cruising}`,
		`Bluewater: ${scores.score_bluewater}`,
		`Pacific Ready: ${scores.score_pacific_ready}`,
		`Single-Hand: ${scores.score_singlehand}`,
		`Liveaboard: ${scores.score_liveaboard}`,
		`Upwind: ${scores.score_upwind}`,
		`Downwind: ${scores.score_downwind}`
	];

	if (listing) {
		lines.push(
			'',
			'## Specific Vessel (Listing)',
			`Asking Price: ${listing.asking_price ? '$' + formatNumber(listing.asking_price) : '?'}`,
			`Location: ${[listing.location_city, listing.location_state].filter(Boolean).join(', ') || '?'}`,
			`Engine Hours: ${listing.engine_hours ?? '?'}`,
			`Condition: ${listing.condition_tier ? formatLabel(listing.condition_tier) : '?'}`,
			`Rigging Age: ${listing.rigging_age_years != null ? listing.rigging_age_years + ' years' : '?'}`,
			`Recent Refit: ${listing.recent_refit ? 'Yes' : 'No'}`
		);
	}

	lines.push(
		'',
		'## Intended Use',
		`Primary: ${use_case_primary}`,
		`Experience Level: ${experience_level}`,
		`Target Waters: ${target_waters}`,
		'',
		'## Analysis Requested',
		'1. Assess this design\'s suitability for the intended use case',
		'2. Flag any structural concerns for offshore passagemaking',
		'3. Evaluate the asking price against comps and condition',
		'4. List the 5 most important pre-purchase survey focus areas',
		'5. Recommend 3 alternative designs if this one has significant gaps'
	);

	return lines.join('\n');
}
