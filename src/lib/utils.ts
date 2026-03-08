export function formatCurrency(value: number): string {
	return new Intl.NumberFormat('en-US', {
		style: 'currency',
		currency: 'USD',
		maximumFractionDigits: 0
	}).format(value);
}

export function formatNumber(value: number): string {
	return new Intl.NumberFormat('en-US').format(value);
}

export function formatLabel(value: string): string {
	return value
		.split('_')
		.map((w) => w.charAt(0).toUpperCase() + w.slice(1))
		.join(' ');
}

export function clamp(value: number, min: number, max: number): number {
	return Math.max(min, Math.min(max, value));
}

export function lerp(value: number, inMin: number, inMax: number, outMin: number, outMax: number): number {
	const t = clamp((value - inMin) / (inMax - inMin), 0, 1);
	return outMin + t * (outMax - outMin);
}
