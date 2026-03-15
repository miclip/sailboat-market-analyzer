import { boats } from '$lib/seed-data';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = ({ url }) => {
	const base = url.origin;

	const staticPages = ['', '/boats', '/compare', '/guide', '/listings/submit'];
	const boatPages = boats.map((b) => `/boats/${b.id}`);

	const urls = [...staticPages, ...boatPages].map(
		(path) => `
  <url>
    <loc>${base}${path}</loc>
    <changefreq>${path.startsWith('/boats/') ? 'weekly' : 'monthly'}</changefreq>
  </url>`
	);

	const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${urls.join('')}
</urlset>`;

	return new Response(xml, {
		headers: {
			'Content-Type': 'application/xml',
			'Cache-Control': 'max-age=3600'
		}
	});
};
