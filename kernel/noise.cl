# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    noise.cl                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: achaussa <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/06/20 18:07:18 by achaussa          #+#    #+#              #
#    Updated: 2018/06/20 18:07:21 by achaussa         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

/*
** Not the definitive hash table but usefull to pick fake fixed random values.
** We need this table with fixed values because of coherence. We don't want our
** noise to change between every lauch of the Ray Tracer.
** And the seed of course to have different versions of the noise itself.
*/

static int 	seed = 20;
static int 	hash[] = {208,34,231,213,32,248,233,56,161,78,24,140,71,48,140,
	254,245,255,247,247,40,185,248,251,245,28,124,204,204,76,36,1,107,28,234,
	163,202,224,245,128,167,204,9,92,217,54,239,174,173,102,193,189,190,121,
	100,108,167,44,43,77,180,204,8,81,70,223,11,38,24,254,210,210,177,32,81,
	195,243,125,8,169,112,32,97,53,195,13,203,9,47,104,125,117,114,124,165,
	203,181,235,193,206,70,180,174,0,167,181,41,164,30,116,127,198,245,146,
	87,224,149,206,57,4,192,210,65,210,129,240,178,105,228,108,245,148,140,
	40,35,195,38,58,65,207,215,253,65,85,208,76,62,3,237,55,89,232,50,217,
	64,244,157,199,121,252,90,17,212,203,149,152,140,187,234,177,73,174,
	193,100,192,143,97,53,145,135,19,103,13,90,135,151,199,91,239,247,33,
	39,145,101,120,99,3,186,86,99,41,237,203,111,79,220,135,158,42,30,154,
	120,67,87,167,135,176,183,191,253,115,184,21,233,58,129,233,142,39,128,
	211,118,137,139,255,114,20,218,113,154,27,127,246,250,1,8,198,250,209,
	92,222,173,21,88,102,219};

/*
** LERP for Linear Interpolation, it helps to interpolate differente values.
*/

float 		lerp(float a, float b, float s)
{
	return (a + s * (b - a));
}

/*
** It "smooth" the shape of a function, it form is: 6t^5 - 15t^4 + 10t^3.
*/

float 		smooth(float s)
{
	return (s * s * s * (s * (s * 6 - 15) + 10));
}

/*
** Run through the hash table of our fake random values with x, y and z.
*/

float		noise3(int x, int y, int z)
{
	int 	tmp;

	tmp = hash[((y + seed) * z) % 256];
	return hash[((tmp + x) * z) % 256];
}

/*
** How to obtain a color with double generated by the material color functions.
*/

float		obtain_color(double red, double green, double blue)
{
	return (((float)(red * 255)) << 16)
		+ (((float)(green * 255)) << 8)
		+ (float)(blue * 255);
}

/*
** Procedural texture function for sinus marble effect.
** c1 is light gray, c2 is white.
*/

float		sin_marble_pixel(t_noise *noise, float x, float y, float z)
{
	c1.x = 0.7;
	c1.y = 0.7;
	c1.z = 0.7;
	c2.x = 1.0;
	c2.y = 1.0;
	c2.z = 1.0;
	value = 1 - sqrt(fabs(sin(2 * 3.141592 *
		perlin3d(x, y, z))));
	result.x = c1.x * (1 - value) + c2.x * value;
	result.y = c1.y * (1 - value) + c2.y * value;
	result.z = c1.z * (1 - value) + c2.z * value;
	return (obtain_color(result.x, result.y, result.z));
}

/*
** Procedural texture function for line marble effect.
** c1 is light gray, c2 is white.
*/

float		line_marble_pixel(t_noise *noise, float x, float y, float z)
{
	c1.x = 0.7;
	c1.y = 0.7;
	c1.z = 0.7;
	c2.x = 1.0;
	c2.y = 1.0;
	c2.z = 1.0;
	lines = 30;
	perturbation = 0.25;
	value = (1 - cos(lines * 2 * PI * ((double)x / TAILLE +
		perturbation * perlin3d(x, y, z)))) / 2;
	result.x = c1.x * (1 - value) + c2.x * value;
	result.y = c1.y * (1 - value) + c2.y * value;
	result.z = c1.z * (1 - value) + c2.z * value;
	return (obtain_color(result.x, result.y, result.z));
}

/*
** Procedural texture function for wood effect.
** c1 is light brown, c2 is dark brown.
*/

float		wood_pixel(t_noise *noise, float x, float y, float z)
{
	c1.x = 0.6;
	c1.y = 0.6;
	c1.z = 0.0;
	c2.x = 0.2;
	c2.y = 0.2;
	c2.z = 0.0;
	threshold = 0.2;
	value1 = (1 - cos(pi * value / (threshold / 2))) / 2;
		value = fmod(perlin3d(x, y, z), threshold);
	if (value > threshold / 2)
		value = threshold - value;
	result.x = c1.x * (1 - value1) + c2.x * value1;
	result.y = c1.y * (1 - value1) + c2.y * value1;
	result.z = c1.z * (1 - value1) + c2.z * value1;
	return (obtain_color(result.x, result.y, result.z));
}

/*
** Return a single value of a noise in 3D.
*/

float		noise3d(t_noise *noise, float x, float y, float z)
{
	x_int = x;
	y_int = y;
	z_int = z;
	x_frac = x - x_int;
	y_frac = y - y_int;
	z_frac = z - z_int;
	s = noise3(x_int, y_int, z_int);
	t = noise3(x_int +1 , y_int, z_int);
	u = noise3(x_int, y_int + 1, z_int);
	v = noise3(x_int + 1, y_int + 1, z_int);
	w = noise3(x_int, y_int, z_int + 1);
	x = noise3(x_int + 1, y_int, z_int + 1);
	y = noise3(x_int, y_int + 1, z_int + 1);
	z = noise3(x_int + 1, y_int + 1, z_int + 1);
	a = lerp(s, t, x_frac);
	b = lerp(u, v, x_frac);
	c = lerp(w, x, x_frac);
	d = lerp(y, z, x_frac);
	low = smooth(a, b, y_frac);
	high = smooth(c, d, y_frac);
	return (lerp(low, high, z_frac));
}

/*
** Call me to have a perfect value for a 3D noise.
*/

float		perlin3d(t_noise *noise, float x, float y, float z)
{
	i = 0;
	fin = 0;
	amp = 1.0;
	freq = 0.1;
	depth = 20;
	xa = x * freq;
	ya = y * freq;
	za = z * freq;
	while (i < depth)
	{
		div += 256 * amp;
		fin += noise2d(xa, ya, za) * amp;
		amp /= 2;
		xa *= 2;
		ya *= 2;
		za *= 2;
		i++;
	}
	return (fin / div);
}
