// src: configs/commitlint.config.js
// @(#) : commitlint configuration for this workspace
/**
 * @version   1.0.0
 * @author    atsushifx <https://github.com/atsushifx/>
 * @since     2025-04-12
 * @license   MIT
 *
 * @description<<
 *
 * This file defines commitlint rules for this project.
 * It loads the standard configuration from @commitlint/config-conventional
 * and applies a formatter for CLI output.
 *
 * <<
 */

// type check for typescript
// import type { UserConfig } from '@commitlint/types'//;

// commit lint common configs
const baseConfig = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      // === Default conventional types ===
      'feat', // New feature
      'fix', // Bug fix
      'chore', // Routine task, maintenance
      'docs', // Documentation only
      'test', // Adding or updating tests
      'refactor', // Code change without fixing a bug or adding a feature
      'perf', // Performance improvement
      'ci', // CI/CD related change

      // === Custom additions ===
      'config', // (custom) For configuration changes
      'release', // (custom) For releases
      'merge', // (custom) For merge commits, especially when conflict resolution involved
      'build', // (custom) For build system or external dependencies
      'style', // (custom) Non-functional code style changes (e.g., formatting, linting)
      'deps', // (custom) Updating third-party dependencies (npm/yarn/etc.)
    ]],
    'subject-case': [2, 'never', ['start-case', 'pascal-case']], // etc
    'header-max-length': [2, 'always', 72],
  },
};

// export
export default baseConfig;
