/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strdup.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/04 18:37:12 by abelov            #+#    #+#             */
/*   Updated: 2023/11/18 20:28:59 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#include <stdlib.h>
#include <errno.h>
#include "libasm.h"

char	*ft_strdup(const char *const src)
{
	char	*new;

	size_t length = ft_strlen(src);
	size_t size = sizeof(char) * length + 1;
	new = (char *)malloc(size);
	ASM_L(.check_alloc);
	if (!new)
	{
		ASM_L(.check_alloc_body);
		errno = ENOMEM;
		new = NULL;
		goto done;
	}
	ASM_L(.malloc_ok);
	*new = '\0';
	new = ft_strcpy(new, src);
ASM_L(.done);
done:
	return (new);
}
