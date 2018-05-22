/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   mlx.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: yguaye <yguaye@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/05/10 17:22:53 by yguaye            #+#    #+#             */
/*   Updated: 2018/05/22 19:08:32 by yguaye           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <mlx.h>
#include "mlx_defs.h"
#include "rt.h"

void				img_mlx_output(t_img *img)
{
	void			*mlx;
	void			*win;
	unsigned int	x;
	unsigned int	y;

	mlx = mlx_init();
	win = mlx_new_window(mlx, (int)img->w, (int)img->h, "rt");
	mlx_hook(win, DESTROYNOTIFY, STRUCTURENOTIFYMASK, &on_window_closing, img);
	mlx_key_hook(win, &on_key_released, img);
	y = 0;
	while (y < img->h)
	{
		x = 0;
		while (x < img->w)
		{
			mlx_pixel_put(mlx, win, (int)x, (int)y, 0 +
					((int)img->data[x][y][0] << 16) +
					((int)img->data[x][y][1] << 8) +
					((int)img->data[x][y][2]));
			++x;
		}
		++y;
	}
	mlx_loop(mlx);
}
