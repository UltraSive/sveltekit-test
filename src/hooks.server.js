/** @type {import('@sveltejs/kit').Handle} */
export async function handle({ event, resolve }) {
	console.log(event.request.url);

    const response = await resolve(event);
	return response;
}