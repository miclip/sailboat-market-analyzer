import type { Boat, BoatScores, ScoreBreakdownItem } from './types';
import { clamp, lerp } from './utils';

function scoreRudder(boat: Boat): { points: number; value: string } {
	const map: Record<string, number> = {
		skeg_hung: 100,
		full_keel_integrated: 85,
		transom_hung: 50,
		spade: 30
	};
	return {
		points: map[boat.rudder_type ?? ''] ?? 50,
		value: boat.rudder_type ?? 'unknown'
	};
}

function scoreKeelBluewater(boat: Boat): { points: number; value: string } {
	const map: Record<string, number> = {
		full: 100,
		modified_fin: 85,
		fin: 50,
		bulb_fin: 45,
		wing: 40,
		centerboard: 30
	};
	return {
		points: map[boat.keel_type ?? ''] ?? 50,
		value: boat.keel_type ?? 'unknown'
	};
}

function scoreMastStep(boat: Boat): { points: number; value: string } {
	return {
		points: boat.mast_step === 'keel_stepped' ? 100 : 40,
		value: boat.mast_step ?? 'unknown'
	};
}

function scoreCapsize(boat: Boat): { points: number; value: string } {
	const csv = boat.capsize_screening_value;
	if (csv == null) return { points: 50, value: 'unknown' };
	// < 2.0 is ideal, > 2.4 is concerning
	const points = clamp(lerp(csv, 2.4, 1.6, 0, 100), 0, 100);
	return { points: Math.round(points), value: csv.toFixed(2) };
}

function scoreDLRatio(boat: Boat, invertForUpwind = false): { points: number; value: string } {
	const dlr = boat.displacement_length_ratio;
	if (dlr == null) return { points: 50, value: 'unknown' };
	// For bluewater: heavier is better (>200 ideal)
	// For upwind: lighter is better (<200 ideal)
	let points: number;
	if (invertForUpwind) {
		points = clamp(lerp(dlr, 350, 150, 0, 100), 0, 100);
	} else {
		points = clamp(lerp(dlr, 100, 300, 0, 100), 0, 100);
	}
	return { points: Math.round(points), value: dlr.toFixed(0) };
}

function scoreMotionComfort(boat: Boat): { points: number; value: string } {
	const mcr = boat.motion_comfort_ratio;
	if (mcr == null) return { points: 50, value: 'unknown' };
	// > 30 is ideal, < 20 is poor
	const points = clamp(lerp(mcr, 15, 40, 0, 100), 0, 100);
	return { points: Math.round(points), value: mcr.toFixed(1) };
}

function scoreCockpit(boat: Boat): { points: number; value: string } {
	return {
		points: boat.cockpit_type === 'center' ? 100 : 60,
		value: boat.cockpit_type ?? 'unknown'
	};
}

function scoreRigSinglehand(boat: Boat): { points: number; value: string } {
	const map: Record<string, number> = {
		ketch: 100,
		cutter: 90,
		yawl: 85,
		sloop: 60,
		schooner: 50
	};
	return {
		points: map[boat.rig_type ?? ''] ?? 50,
		value: boat.rig_type ?? 'unknown'
	};
}

function scoreSelfSteering(boat: Boat): { points: number; value: string } {
	return {
		points: boat.self_steering_compatible ? 100 : 20,
		value: boat.self_steering_compatible ? 'yes' : 'no'
	};
}

function scoreLOASinglehand(boat: Boat): { points: number; value: string } {
	const loa = boat.length_ft;
	if (loa == null) return { points: 50, value: 'unknown' };
	// < 45ft is ideal for singlehand, > 55ft gets tough
	const points = clamp(lerp(loa, 60, 35, 0, 100), 0, 100);
	return { points: Math.round(points), value: `${loa}ft` };
}

function scoreSAD(boat: Boat): { points: number; value: string } {
	const sad = boat.sa_displacement_ratio;
	if (sad == null) return { points: 50, value: 'unknown' };
	// Higher = more sail power relative to weight = better upwind
	const points = clamp(lerp(sad, 12, 20, 0, 100), 0, 100);
	return { points: Math.round(points), value: sad.toFixed(1) };
}

function scoreSADSinglehand(boat: Boat): { points: number; value: string } {
	const sad = boat.sa_displacement_ratio;
	if (sad == null) return { points: 50, value: 'unknown' };
	// Moderate is best for singlehand — not underpowered, not overpowered
	// 15-17 is ideal
	let points: number;
	if (sad < 15) {
		points = lerp(sad, 10, 15, 30, 100);
	} else if (sad > 18) {
		points = lerp(sad, 18, 23, 100, 30);
	} else {
		points = 100;
	}
	return { points: Math.round(clamp(points, 0, 100)), value: sad.toFixed(1) };
}

function scoreKeelUpwind(boat: Boat): { points: number; value: string } {
	const map: Record<string, number> = {
		fin: 100,
		modified_fin: 85,
		bulb_fin: 90,
		wing: 80,
		full: 40,
		centerboard: 60
	};
	return {
		points: map[boat.keel_type ?? ''] ?? 50,
		value: boat.keel_type ?? 'unknown'
	};
}

function scoreBeamUpwind(boat: Boat): { points: number; value: string } {
	const beam = boat.beam_ft;
	if (beam == null) return { points: 50, value: 'unknown' };
	// Narrower is better upwind (relatively)
	const points = clamp(lerp(beam, 16, 10, 0, 100), 0, 100);
	return { points: Math.round(points), value: `${beam}ft` };
}

function scoreDisplacementDownwind(boat: Boat): { points: number; value: string } {
	const disp = boat.displacement_lbs;
	if (disp == null) return { points: 50, value: 'unknown' };
	// Heavier = more stable downwind
	const points = clamp(lerp(disp, 10000, 35000, 0, 100), 0, 100);
	return { points: Math.round(points), value: `${disp}lbs` };
}

function scoreKeelDownwind(boat: Boat): { points: number; value: string } {
	const map: Record<string, number> = {
		full: 100,
		modified_fin: 80,
		fin: 50,
		bulb_fin: 55,
		wing: 45,
		centerboard: 40
	};
	return {
		points: map[boat.keel_type ?? ''] ?? 50,
		value: boat.keel_type ?? 'unknown'
	};
}

function scoreForefootDownwind(boat: Boat): { points: number; value: string } {
	const map: Record<string, number> = {
		deep: 100,
		moderate: 70,
		cut_away: 40
	};
	return {
		points: map[boat.forefoot_depth ?? ''] ?? 50,
		value: boat.forefoot_depth ?? 'unknown'
	};
}

function scoreLiveaboard(boat: Boat): { points: number; value: string } {
	const loa = boat.length_ft;
	if (loa == null) return { points: 50, value: 'unknown' };
	// Bigger = more liveable
	const points = clamp(lerp(loa, 30, 55, 0, 100), 0, 100);
	return { points: Math.round(points), value: `${loa}ft` };
}

function scoreBeamLiveaboard(boat: Boat): { points: number; value: string } {
	const beam = boat.beam_ft;
	if (beam == null) return { points: 50, value: 'unknown' };
	// Wider = more room
	const points = clamp(lerp(beam, 10, 15, 0, 100), 0, 100);
	return { points: Math.round(points), value: `${beam}ft` };
}

function weighted(items: { points: number; weight: number }[]): number {
	return Math.round(items.reduce((sum, item) => sum + item.points * item.weight, 0));
}

function breakdown(
	items: { factor: string; weight: number; points: number; value: string }[]
): ScoreBreakdownItem[] {
	return items.map(({ factor, weight, points, value }) => ({
		factor,
		weight,
		value,
		points
	}));
}

export function computeScores(boat: Boat): BoatScores {
	// Bluewater
	const bwRudder = { ...scoreRudder(boat), factor: 'Rudder Type', weight: 0.25 };
	const bwKeel = { ...scoreKeelBluewater(boat), factor: 'Keel Type', weight: 0.2 };
	const bwMast = { ...scoreMastStep(boat), factor: 'Mast Step', weight: 0.15 };
	const bwCapsize = { ...scoreCapsize(boat), factor: 'Capsize Screening', weight: 0.2 };
	const bwDLR = { ...scoreDLRatio(boat), factor: 'D/L Ratio', weight: 0.1 };
	const bwMCR = { ...scoreMotionComfort(boat), factor: 'Motion Comfort', weight: 0.1 };
	const bluewaterItems = [bwRudder, bwKeel, bwMast, bwCapsize, bwDLR, bwMCR];
	const score_bluewater = weighted(bluewaterItems);

	// Singlehand
	const shCockpit = { ...scoreCockpit(boat), factor: 'Cockpit Type', weight: 0.2 };
	const shRig = { ...scoreRigSinglehand(boat), factor: 'Rig Type', weight: 0.2 };
	const shMast = {
		factor: 'Mast Step',
		weight: 0.1,
		points: boat.mast_step === 'deck_stepped' ? 40 : 80,
		value: boat.mast_step ?? 'unknown'
	};
	const shSteering = { ...scoreSelfSteering(boat), factor: 'Self-Steering', weight: 0.2 };
	const shLOA = { ...scoreLOASinglehand(boat), factor: 'LOA', weight: 0.15 };
	const shSAD = { ...scoreSADSinglehand(boat), factor: 'SA/D Ratio', weight: 0.15 };
	const singlehandItems = [shCockpit, shRig, shMast, shSteering, shLOA, shSAD];
	const score_singlehand = weighted(singlehandItems);

	// Liveaboard
	const laSize = { ...scoreLiveaboard(boat), factor: 'LOA', weight: 0.35 };
	const laBeam = { ...scoreBeamLiveaboard(boat), factor: 'Beam', weight: 0.3 };
	const laMCR = { ...scoreMotionComfort(boat), factor: 'Motion Comfort', weight: 0.2 };
	const laGen = {
		factor: 'Generator',
		weight: 0.15,
		points: boat.generator_standard ? 100 : 30,
		value: boat.generator_standard ? 'yes' : 'no'
	};
	const liveaboardItems = [laSize, laBeam, laMCR, laGen];
	const score_liveaboard = weighted(liveaboardItems);

	// Pacific Ready = Bluewater(60%) + Singlehand(20%) + Liveaboard(20%)
	const score_pacific_ready = Math.round(
		score_bluewater * 0.6 + score_singlehand * 0.2 + score_liveaboard * 0.2
	);

	// Coastal Cruising — lighter scoring, broader appeal
	const ccMCR = { ...scoreMotionComfort(boat), factor: 'Motion Comfort', weight: 0.3 };
	const ccSize = { ...scoreLiveaboard(boat), factor: 'LOA', weight: 0.25 };
	const ccSAD = { ...scoreSAD(boat), factor: 'SA/D Ratio', weight: 0.25 };
	const ccBeam = { ...scoreBeamLiveaboard(boat), factor: 'Beam', weight: 0.2 };
	const coastalItems = [ccMCR, ccSize, ccSAD, ccBeam];
	const score_coastal_cruising = weighted(coastalItems);

	// Upwind
	const uwSAD = { ...scoreSAD(boat), factor: 'SA/D Ratio', weight: 0.3 };
	const uwKeel = { ...scoreKeelUpwind(boat), factor: 'Keel Type', weight: 0.3 };
	const uwDLR = { ...scoreDLRatio(boat, true), factor: 'D/L Ratio', weight: 0.2 };
	const uwBeam = { ...scoreBeamUpwind(boat), factor: 'Beam', weight: 0.2 };
	const upwindItems = [uwSAD, uwKeel, uwDLR, uwBeam];
	const score_upwind = weighted(upwindItems);

	// Downwind
	const dwDisp = { ...scoreDisplacementDownwind(boat), factor: 'Displacement', weight: 0.3 };
	const dwKeel = { ...scoreKeelDownwind(boat), factor: 'Keel Type', weight: 0.25 };
	const dwMCR = { ...scoreMotionComfort(boat), factor: 'Motion Comfort', weight: 0.25 };
	const dwForefoot = { ...scoreForefootDownwind(boat), factor: 'Forefoot Depth', weight: 0.2 };
	const downwindItems = [dwDisp, dwKeel, dwMCR, dwForefoot];
	const score_downwind = weighted(downwindItems);

	return {
		boat_id: boat.id,
		score_coastal_cruising,
		score_bluewater,
		score_pacific_ready,
		score_singlehand,
		score_liveaboard,
		score_upwind,
		score_downwind,
		score_breakdown: {
			coastal_cruising: breakdown(coastalItems),
			bluewater: breakdown(bluewaterItems),
			singlehand: breakdown(singlehandItems),
			liveaboard: breakdown(liveaboardItems),
			upwind: breakdown(upwindItems),
			downwind: breakdown(downwindItems)
		}
	};
}
