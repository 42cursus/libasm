/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   libasm.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/07 16:47:05 by abelov            #+#    #+#             */
/*   Updated: 2026/04/07 16:47:05 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef LIBASM_H
#define LIBASM_H

#include <stddef.h>
#include <sys/types.h>

/* string */
size_t	ft_strlen(const char *src);
char	*ft_strcpy(char *dest, const char *src);
int		ft_strcmp(const char *s1, const char *s2);
char	*ft_strdup(const char *src);

/* io (syscall wrappers; set errno on failure) */
ssize_t	ft_write(int fd, const char *buf, size_t size);
ssize_t	ft_read(int fd, void *buf, size_t count);

#endif //LIBASM_H
