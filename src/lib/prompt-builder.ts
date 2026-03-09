import type { PromptInputs, PromptListingSummary } from './types';
import { formatLabel, formatNumber } from './utils';

function formatListingSummary(l: PromptListingSummary, index: number): string[] {
	const lines: string[] = [];
	const label = `### Listing ${index + 1}`;
	lines.push(label);
	lines.push(`URL: ${l.url}`);
	if (l.year) lines.push(`Year Built: ${l.year}`);
	if (l.asking_price) lines.push(`Asking Price: $${formatNumber(l.asking_price)}`);
	if (l.location) lines.push(`Location: ${l.location}`);
	if (l.engine_info) lines.push(`Engine: ${l.engine_info}`);
	if (l.engine_hours != null) lines.push(`Engine Hours: ${formatNumber(l.engine_hours)}`);
	if (l.hull_material) lines.push(`Hull Material: ${l.hull_material}`);
	if (l.condition) lines.push(`Condition: ${l.condition}`);
	if (l.rigging_age_years != null) lines.push(`Rigging Age: ${l.rigging_age_years} years`);
	if (l.sails_condition) lines.push(`Sails: ${l.sails_condition}`);
	if (l.electronics_age_years != null) lines.push(`Electronics Age: ${l.electronics_age_years} years`);
	if (l.recent_refit) lines.push(`Recent Refit: Yes${l.refit_notes ? ' — ' + l.refit_notes : ''}`);
	if (l.days_on_market != null) lines.push(`Days on Market: ${l.days_on_market}`);
	if (l.description) {
		// Truncate long descriptions
		const desc = l.description.length > 500 ? l.description.slice(0, 500) + '...' : l.description;
		lines.push(`Description: ${desc}`);
	}
	return lines;
}

export function buildPrompt(inputs: PromptInputs): string {
	const { boat, scores, listing, activeListings, comps, use_case_primary, experience_level, target_waters } = inputs;

	const lines: string[] = [
		'You are evaluating a bluewater sailing vessel for purchase. Review the design data, scoring, and any active listings below. Where listing URLs are provided, you may browse them for photos, full descriptions, and broker details.',
		'',
		'## Vessel Design',
		`Design: ${boat.design_name} (${boat.year_range_start ?? '?'}–${boat.year_range_end ?? '?'})`,
		`Manufacturer: ${boat.manufacturer}`,
		`LOA: ${boat.length_ft ?? '?'}ft | Beam: ${boat.beam_ft ?? '?'}ft | LWL: ${boat.lwl_ft ?? '?'}ft`,
		`Displacement: ${boat.displacement_lbs ? formatNumber(boat.displacement_lbs) + 'lbs' : '?'} | Ballast: ${boat.ballast_lbs ? formatNumber(boat.ballast_lbs) + 'lbs' : '?'}`,
		`Ballast Ratio: ${boat.ballast_ratio ? (boat.ballast_ratio * 100).toFixed(0) + '%' : '?'} | D/L Ratio: ${boat.displacement_length_ratio?.toFixed(0) ?? '?'}`,
		`SA/D Ratio: ${boat.sa_displacement_ratio?.toFixed(1) ?? '?'} | Sail Area: ${boat.sail_area_sqft ? formatNumber(boat.sail_area_sqft) + 'sqft' : '?'}`,
		`Capsize Screening Value: ${boat.capsize_screening_value?.toFixed(2) ?? '?'} (< 2.0 is offshore capable)`,
		`Motion Comfort Ratio: ${boat.motion_comfort_ratio?.toFixed(1) ?? '?'} (30+ good for bluewater)`,
		'',
		'## Structural Characteristics',
		`Rudder: ${boat.rudder_type ? formatLabel(boat.rudder_type) : '?'}`,
		`Keel: ${boat.keel_type ? formatLabel(boat.keel_type) : '?'}`,
		`Hull: ${boat.hull_type ? formatLabel(boat.hull_type) : '?'}`,
		`Stern: ${boat.stern_type ? formatLabel(boat.stern_type) : '?'}`,
		`Mast Step: ${boat.mast_step ? formatLabel(boat.mast_step) : '?'}`,
		`Rig: ${boat.rig_type ? formatLabel(boat.rig_type) : '?'}`,
		`Cockpit: ${boat.cockpit_type ? formatLabel(boat.cockpit_type) : '?'}`,
		`Galley: ${boat.galley_layout ? formatLabel(boat.galley_layout) : '?'}`,
		`Backstay: ${boat.has_backstay == null ? '?' : boat.has_backstay ? 'Yes' : 'No'}`,
		`Teak Decks: ${boat.has_teak_decks == null ? '?' : boat.has_teak_decks ? 'Yes' : 'No'}`,
		'',
		'## Interior',
		`Cabins: ${boat.cabins ?? '?'} | Berths: ${boat.berths ?? '?'} | Sea Berths: ${boat.sea_berths ?? '?'}`,
		'',
		'## Use-Case Scores (0–100)',
		`Coastal Cruising: ${scores.score_coastal_cruising}`,
		`Bluewater: ${scores.score_bluewater}`,
		`Pacific Ready: ${scores.score_pacific_ready}`,
		`Single-Hand: ${scores.score_singlehand}`,
		`Liveaboard: ${scores.score_liveaboard}`,
		`Upwind: ${scores.score_upwind}`,
		`Downwind: ${scores.score_downwind}`
	];

	if (boat.notes) {
		lines.push('', `Design Notes: ${boat.notes}`);
	}

	// Include the primary listing from our DB if present
	if (listing) {
		lines.push(
			'',
			'## Primary Listing Under Evaluation',
			`URL: ${listing.listing_url ?? listing.boattrader_url ?? listing.yachtworld_url ?? 'N/A'}`,
			`Asking Price: ${listing.asking_price ? '$' + formatNumber(listing.asking_price) : '?'}`,
			`Year Built: ${listing.year_built ?? '?'}`,
			`Location: ${[listing.location_city, listing.location_state].filter(Boolean).join(', ') || '?'}`,
			`Engine: ${[listing.engine_make, listing.engine_model].filter(Boolean).join(' ') || '?'} ${listing.engine_hp ? `(${listing.engine_hp}hp)` : ''}`,
			`Engine Hours: ${listing.engine_hours ?? '?'}${listing.engine_year ? ` (engine year: ${listing.engine_year})` : ''}`,
			`Hull Material: ${listing.hull_material ?? '?'}`,
			`Condition: ${listing.condition_tier ? formatLabel(listing.condition_tier) : '?'}`,
			`Rigging Age: ${listing.rigging_age_years != null ? listing.rigging_age_years + ' years' : '?'}`,
			`Sails: ${listing.sails_condition ? formatLabel(listing.sails_condition) : '?'}`,
			`Electronics Age: ${listing.electronics_age_years != null ? listing.electronics_age_years + ' years' : '?'}`,
			`Recent Refit: ${listing.recent_refit ? 'Yes' : 'No'}${listing.refit_notes ? ' — ' + listing.refit_notes : ''}`,
			`Days on Market: ${listing.days_on_market ?? '?'}`
		);
		if (listing.description) {
			const desc = listing.description.length > 500 ? listing.description.slice(0, 500) + '...' : listing.description;
			lines.push(`Description: ${desc}`);
		}
	}

	// Include active BoatTrader listings with browsable URLs
	if (activeListings && activeListings.length > 0) {
		lines.push(
			'',
			'## Active Listings (browse these URLs for photos and full details)',
			`${activeListings.length} listing${activeListings.length !== 1 ? 's' : ''} found:`
		);
		for (let i = 0; i < activeListings.length; i++) {
			lines.push('', ...formatListingSummary(activeListings[i], i));
		}
	}

	// Include comp data
	if (comps && comps.length > 0) {
		lines.push('', '## Recent Comparable Sales');
		for (const comp of comps) {
			const parts = [];
			if (comp.reported_sale_price) parts.push(`$${formatNumber(comp.reported_sale_price)}`);
			if (comp.sale_date) parts.push(`sold ${comp.sale_date}`);
			if (comp.reporter_role) parts.push(`reported by ${comp.reporter_role}`);
			if (comp.verified) parts.push('(verified)');
			if (comp.notes) parts.push(`— ${comp.notes}`);
			lines.push(`- ${parts.join(' ')}`);
		}
	}

	lines.push(
		'',
		'## Buyer Profile',
		`Primary Use Case: ${use_case_primary}`,
		`Experience Level: ${experience_level}`,
		`Target Waters: ${target_waters}`,
		'',
		'## Analysis Requested',
		'1. **Design Assessment**: How well does this design suit the intended use case? What are its strengths and weaknesses for these waters?',
		'2. **Structural Concerns**: Flag any design characteristics that are concerning for the intended use (rudder vulnerability, rigging issues, deck hardware, etc.)',
		'3. **Listing Evaluation**: If listing data is provided, evaluate the asking price against condition, age, engine hours, and comparable sales. What is a fair offer range?',
		'4. **Survey Focus Areas**: List the 5 most critical pre-purchase survey items for this specific design and age',
		'5. **Refit Budget Estimate**: Based on condition data, estimate the likely refit budget to make this boat passage-ready for the target waters',
		'6. **Alternative Designs**: If this design has significant gaps for the use case, suggest 2-3 better-suited alternatives and explain why'
	);

	return lines.join('\n');
}
