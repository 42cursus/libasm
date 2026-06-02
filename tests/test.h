/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test.h                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/06/02 21:13:49 by abelov            #+#    #+#             */
/*   Updated: 2026/06/02 21:13:49 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

/*
 * Minimal, assert-based test harness for ft_libasm.
 *
 * Each suite is a single function `void test_<name>(void)`. Inside, use the
 * ASSERT_* macros below. They:
 *   - count one test on every invocation (g_test_count)
 *   - print a one-line diagnostic and increment g_test_failed on mismatch
 *   - never abort the process — execution continues so a single failing
 *     suite does not hide the rest
 *
 * main() in tests/main.c calls every suite and exits non-zero if any
 * assertion failed.
 */

#ifndef LIBASM_TEST_H
#define LIBASM_TEST_H

#include <stddef.h>
#include <stdio.h>
#include <string.h>

extern unsigned long g_test_count;
extern unsigned long g_test_failed;

#define TEST_FAIL_(fmt, ...) \
	do { \
		g_test_failed++; \
		fprintf(stderr, "FAIL %s:%d in %s: " fmt "\n", \
			__FILE__, __LINE__, __func__, __VA_ARGS__); \
	} while (0)

#define ASSERT_TRUE(expr) \
	do { \
		g_test_count++; \
		if (!(expr)) \
			TEST_FAIL_("%s", "expected " #expr); \
	} while (0)

#define ASSERT_EQ_INT(actual, expected) \
	do { \
		long long _a = (long long)(actual); \
		long long _e = (long long)(expected); \
		g_test_count++; \
		if (_a != _e) \
			TEST_FAIL_("%s == %lld, got %lld", #actual, _e, _a); \
	} while (0)

#define ASSERT_EQ_SIZE(actual, expected) \
	do { \
		size_t _a = (size_t)(actual); \
		size_t _e = (size_t)(expected); \
		g_test_count++; \
		if (_a != _e) \
			TEST_FAIL_("%s == %zu, got %zu", #actual, _e, _a); \
	} while (0)

#define ASSERT_STR_EQ(actual, expected) \
	do { \
		const char *_a = (actual); \
		const char *_e = (expected); \
		g_test_count++; \
		if (_a == NULL || _e == NULL || strcmp(_a, _e) != 0) \
			TEST_FAIL_("%s == \"%s\", got \"%s\"", #actual, \
				_e ? _e : "(null)", _a ? _a : "(null)"); \
	} while (0)

/* Compare two ints by sign only (negative / zero / positive). Useful for
 * strcmp-style return values where the exact magnitude is unspecified. */
#define ASSERT_SAME_SIGN(actual, expected) \
	do { \
		int _a = (int)(actual); \
		int _e = (int)(expected); \
		int _as = (_a > 0) - (_a < 0); \
		int _es = (_e > 0) - (_e < 0); \
		g_test_count++; \
		if (_as != _es) \
			TEST_FAIL_("sign(%s)=%d, expected %d (actual=%d)", \
				#actual, _as, _es, _a); \
	} while (0)

#define RUN_SUITE(suite_fn) \
	do { \
		unsigned long _before = g_test_failed; \
		fprintf(stderr, "  - " #suite_fn " ... "); \
		suite_fn(); \
		fprintf(stderr, "%s\n", g_test_failed == _before ? "ok" : "FAIL"); \
	} while (0)

#endif /* LIBASM_TEST_H */
