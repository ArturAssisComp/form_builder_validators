import '../../localization/l10n.dart';
import 'constants.dart';

/// {@template validator_is_after}
/// Creates a [DateTime] validator that checks if an input date occurs after
/// `reference`.
///
/// ## Parameters
/// - `reference` (`DateTime`): The baseline date against which the input will be compared.
///   This serves as the minimum acceptable date (exclusive by default).
/// - `isAfterMsg` (`String Function(DateTime input, DateTime reference)?`): Optional custom
///   error message generator. When provided, it receives both the input and reference
///   dates to construct a context-aware error message.
/// - `inclusive` (`bool`): When set to `true`, allows the input date to exactly match
///   the reference date. Defaults to `false`, requiring strictly later dates.
///
/// ## Returns
/// Returns a `Validator<DateTime>` function that:
/// - Returns `null` if validation passes (input is after reference)
/// - Returns an error message string if validation fails
///
/// ## Examples
/// ```dart
/// // Basic usage requiring date after January 1st, 2025
/// final validator = isAfter(DateTime(2025));
///
/// // Inclusive validation allowing exact match
/// final inclusiveValidator = isAfter(
///   DateTime(2024),
///   inclusive: true,
/// );
///
/// // Custom error message
/// final customValidator = isAfter(
///   DateTime(2024),
///   isAfterMsg: (_, ref) => 'Please select a date after ${ref.toString()}',
/// );
/// ```
/// {@endtemplate}
Validator<DateTime> isAfter(
  DateTime reference, {
  String Function(DateTime input, DateTime reference)? isAfterMsg,
  bool inclusive = false,
}) {
  return (DateTime input) {
    return input.isAfter(reference) ||
            (inclusive ? input.isAtSameMomentAs(reference) : false)
        ? null
        : isAfterMsg?.call(input, reference) ??
            FormBuilderLocalizations.current
                .dateMustBeAfterErrorText(reference.toLocal());
  };
}

/// {@template validator_is_before}
/// Creates a [DateTime] validator that checks if an input date occurs before
/// `reference`.
///
/// ## Parameters
/// - `reference` (`DateTime`): The baseline date against which the input will be compared.
///   This serves as the maximum acceptable date (exclusive by default).
/// - `isBeforeMsg` (`String Function(DateTime input, DateTime reference)?`): Optional custom
///   error message generator. When provided, it receives both the input and reference
///   dates to construct a context-aware error message.
/// - `inclusive` (`bool`): When set to `true`, allows the input date to exactly match
///   the reference date. Defaults to `false`, requiring strictly earlier dates.
///
/// ## Returns
/// Returns a `Validator<DateTime>` function that:
/// - Returns `null` if validation passes (input is before reference)
/// - Returns an error message string if validation fails. If no custom message is provided,
///   falls back to the localized error text from `FormBuilderLocalizations`
///
/// ## Examples
/// ```dart
/// // Basic usage requiring date before January 1st, 2025
/// final validator = isBefore(DateTime(2025));
///
/// // Inclusive validation allowing exact match
/// final inclusiveValidator = isBefore(
///   DateTime(2024),
///   inclusive: true,
/// );
///
/// // Custom error message
/// final customValidator = isBefore(
///   DateTime(2024),
///   isBeforeMsg: (_, ref) => 'Please select a date before ${ref.toString()}',
/// );
/// ```
/// {@endtemplate}
Validator<DateTime> isBefore(
  DateTime reference, {
  String Function(DateTime input, DateTime reference)? isBeforeMsg,
  bool inclusive = false,
}) {
  return (DateTime input) {
    return input.isBefore(reference) ||
            (inclusive ? input.isAtSameMomentAs(reference) : false)
        ? null
        : isBeforeMsg?.call(input, reference) ??
            FormBuilderLocalizations.current
                .dateMustBeBeforeErrorText(reference.toLocal());
  };
}

/// {@template validator_is_date_time_between}
/// Creates a [DateTime] validator that checks if an input date falls within a specified
/// range defined by `minReference` and `maxReference`.
///
/// The validator ensures the input date occurs after `minReference` and before
/// `maxReference`, with optional inclusive boundaries controlled by `minInclusive`
/// and `maxInclusive` parameters.
///
/// ## Parameters
/// - `minReference` (`DateTime`): The lower bound of the acceptable date range.
///   Input dates must occur after this date (or equal to it if `minInclusive` is true).
/// - `maxReference` (`DateTime`): The upper bound of the acceptable date range.
///   Input dates must occur before this date (or equal to it if `maxInclusive` is true).
/// - `isDateTimeBetweenMsg` (`String Function(DateTime, DateTime, DateTime)?`): Optional
///   custom error message generator. When provided, it receives the input date and both
///   reference dates to construct a context-aware error message.
/// - `minInclusive` (`bool`): When set to `true`, allows the input date to exactly match
///   the `minReference` date. Defaults to `false`.
/// - `maxInclusive` (`bool`): When set to `true`, allows the input date to exactly match
///   the `maxReference` date. Defaults to `false`.
///
/// ## Returns
/// Returns a `Validator<DateTime>` function that:
/// - Returns `null` if validation passes (input is within the specified range)
/// - Returns an error message string if validation fails. If no custom message is provided,
///   falls back to the localized error text from `FormBuilderLocalizations`
///
/// ## Throws
/// - `AssertionError`: When `minReference` is not chronologically before `maxReference`,
///   indicating an invalid date range configuration.
///
/// ## Examples
/// ```dart
/// // Basic usage requiring date between 2023 and 2025
/// final validator = isDateTimeBetween(
///   DateTime(2023),
///   DateTime(2025),
/// );
///
/// // Inclusive validation allowing exact matches
/// final inclusiveValidator = isDateTimeBetween(
///   DateTime(2023),
///   DateTime(2025),
///   minInclusive: true,
///   maxInclusive: true,
/// );
///
/// // Custom error message
/// final customValidator = isDateTimeBetween(
///   DateTime(2023),
///   DateTime(2025),
///   isDateTimeBetweenMsg: (_, min, max) =>
///     'Please select a date between ${min.toString()} and ${max.toString()}',
/// );
/// ```
/// {@endtemplate}
Validator<DateTime> isDateTimeBetween(
  DateTime minReference,
  DateTime maxReference, {
  String Function(DateTime input, DateTime minReference, DateTime maxReference)?
      isDateTimeBetweenMsg,
  bool minInclusive = false,
  bool maxInclusive = false,
}) {
  assert(minReference.isBefore(maxReference),
      'leftReference must be before rightReference');
  return (DateTime input) {
    return (input.isBefore(maxReference) ||
                (maxInclusive
                    ? input.isAtSameMomentAs(maxReference)
                    : false)) &&
            (input.isAfter(minReference) ||
                (minInclusive ? input.isAtSameMomentAs(minReference) : false))
        ? null
        : isDateTimeBetweenMsg?.call(input, minReference, maxReference) ??
            FormBuilderLocalizations.current.dateMustBeBetweenErrorText(
                minReference.toLocal(), maxReference.toLocal());
  };
}

/// {@template validator_is_in_past}
/// Creates a [DateTime] validator that checks if an input date occurs in the past,
/// which means before the current time ([DateTime.now]), computed while executing
/// this validation.
///
/// ## Parameters
/// - `isInThePastMsg` (`String Function(DateTime input)?`): Optional custom
///   error message generator. When provided, it receives the input date to
///   construct a context-aware error message.
///
/// ## Returns
/// Returns a `Validator<DateTime>` function that:
/// - Returns `null` if validation passes (input date is in the past)
/// - Returns an error message string if validation fails. If no custom message
///   is provided, falls back to the localized error text from
///   `FormBuilderLocalizations`
///
///
/// ## Examples
/// ```dart
/// // Basic usage requiring a past date
/// final validator = isInThePast();
///
/// // Custom error message
/// final customValidator = isInThePast(
///   isInThePastMsg: (input) =>
///     'Selected date (${input.toString()}) must be in the past',
/// );
/// ```
///
/// ## Caveats
/// - The validation uses [DateTime.now] as the reference point, which means
///   the valid date range continuously changes as time progresses
/// {@endtemplate}
Validator<DateTime> isInThePast({
  String Function(DateTime input)? isInThePastMsg,
}) {
  return (DateTime input) {
    return input.isBefore(DateTime.now())
        ? null
        : isInThePastMsg?.call(input) ??
            FormBuilderLocalizations.current.dateMustBeInThePastErrorText;
  };
}

/// {@template validator_is_in_future}
/// Creates a [DateTime] validator that checks if an input date occurs in the future,
/// which means after the current time ([DateTime.now]), computed while executing
/// this validation.
///
/// ## Parameters
/// - `isInTheFutureMsg` (`String Function(DateTime input)?`): Optional custom
///   error message generator. When provided, it receives the input date to
///   construct a context-aware error message.
///
/// ## Returns
/// Returns a `Validator<DateTime>` function that:
/// - Returns `null` if validation passes (input date is in the future)
/// - Returns an error message string if validation fails. If no custom message
///   is provided, falls back to the localized error text from
///   `FormBuilderLocalizations`
///
/// ## Examples
/// ```dart
/// // Basic usage requiring a future date
/// final validator = isInFuture();
///
/// // Custom error message
/// final customValidator = isInFuture(
///   isInFutureMsg: (input) =>
///     'Selected date (${input.toString()}) must be in the future',
/// );
/// ```
///
/// ## Caveats
/// - The validation uses [DateTime.now] as the reference point, which means
///   the valid date range continuously changes as time progresses
/// {@endtemplate}
Validator<DateTime> isInTheFuture({
  String Function(DateTime input)? isInTheFutureMsg,
}) {
  return (DateTime input) {
    return input.isAfter(DateTime.now())
        ? null
        : isInTheFutureMsg?.call(input) ??
            FormBuilderLocalizations.current.dateMustBeInTheFutureErrorText;
  };
}
