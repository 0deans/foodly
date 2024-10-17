import * as React from 'react';
import { Outlet, createRootRoute } from '@tanstack/react-router';

export const Route = createRootRoute({
	component: () => (
		<React.Fragment>
			<Outlet />
			<div className="dark hidden">
				Tailwind removes unused styles by default, but we include it in index.html just to enable
				dark mode. It’s kind of a hack to keep those styles from being removed.
			</div>
		</React.Fragment>
	)
});
