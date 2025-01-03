import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../localization/intl/app_localizations.dart';
import '../override_form_builder_localizations_en.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// The main application widget constructor.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '(New API) Form Builder Validators Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewAPIHomePage(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        ...GlobalMaterialLocalizations.delegates,
        // Placed in front of `FormBuilderLocalizations.delegate`
        ...AppLocalizations.localizationsDelegates,
        OverrideFormBuilderLocalizationsEn.delegate,
        FormBuilderLocalizations.delegate,
      ],
    );
  }
}

/// Represents the home page of the application.
class NewAPIHomePage extends StatelessWidget {
  /// Constructs a new instance of the [NewAPIHomePage] class.
  const NewAPIHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('(New API) Form Builder Validators')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Composing multiple validators
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator:
                    FormBuilderValidators.compose(<FormFieldValidator<String>>[
                  isRequired(
                    isNum(lessThanOrEqualTo(70),
                        (_) => 'La edad debe ser numérica.'),
                  ),

                  /// Include your own custom `FormFieldValidator` function, if you want
                  /// Ensures positive values only. We could also have used `FormBuilderValidators.min( 0)` instead
                  (String? val) {
                    if (val != null) {
                      final int? number = int.tryParse(val);
                      if (number == null) return null;
                      if (number < 0) return 'We cannot have a negative age';
                    }
                    return null;
                  }
                ]),

                /*
                // Original api
                    FormBuilderValidators.compose(<FormFieldValidator<String>>[
                  /// Makes this field required
                  FormBuilderValidators.required(),

                  /// Ensures the value entered is numeric - with custom error message
                  FormBuilderValidators.numeric(
                    errorText: 'La edad debe ser numérica.',
                  ),

                  /// Sets a maximum value of 70
                  FormBuilderValidators.max(70),

                  /// Include your own custom `FormFieldValidator` function, if you want
                  /// Ensures positive values only. We could also have used `FormBuilderValidators.min( 0)` instead
                  (String? val) {
                    if (val != null) {
                      final int? number = int.tryParse(val);
                      if (number == null) return null;
                      if (number < 0) return 'We cannot have a negative age';
                    }
                    return null;
                  }
                ]),

                     */
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Age (better way to do)'),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: isRequired(
                  isNum(
                    and([
                      lessThanOrEqualTo(70),
                      (num value) {
                        if (value < 0) return 'We cannot have a negative age';

                        return null;
                      },
                    ]),
                    (_) => 'La edad debe ser numérica.',
                  ),
                ),
              ),

              // Required Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Required Field',
                  prefixIcon: Icon(Icons.star),
                ),
                // validator: FormBuilderValidators.required(),
                validator: isRequired(null),
                autofillHints: const <String>[AutofillHints.name],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Numeric Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Numeric Field',
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                //validator: FormBuilderValidators.numeric(),
                // To maintain the previous behavior, we use msg. Below, there is a more precise way of doing that.
                validator: overrideErrorMsg(
                    (_) => FormBuilderLocalizations.current.numericErrorText,
                    isRequired(isNum(null))),

                autofillHints: const <String>[AutofillHints.oneTimeCode],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Numeric Field (more precise message)',
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                //validator: FormBuilderValidators.numeric(),
                validator: isRequired(isNum(null)),
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Email Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email Field',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                //validator: FormBuilderValidators.email(),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.emailErrorText,
                  isRequired(email()),
                ),
                autofillHints: const <String>[AutofillHints.email],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // URL Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'URL Field',
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                //validator: FormBuilderValidators.url(),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.urlErrorText,
                  isRequired(url()),
                ),
                autofillHints: const <String>[AutofillHints.url],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Min Length Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Min Length Field',
                  prefixIcon: Icon(Icons.text_fields),
                ),
                //validator: FormBuilderValidators.minLength(5),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.minLengthErrorText(5),
                  isRequired(minLength(5)),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Max Length Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Max Length Field',
                  prefixIcon: Icon(Icons.text_fields),
                ),
                //validator: FormBuilderValidators.maxLength(10),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.maxLengthErrorText(5),
                  isRequired(maxLength(5)),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Min Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Min Value Field',
                  prefixIcon: Icon(Icons.exposure_neg_1),
                ),
                keyboardType: TextInputType.number,
                //validator: FormBuilderValidators.min(10),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.minErrorText(10),
                  isRequired(isNum(greaterThanOrEqualTo(10))),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Max Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Max Value Field',
                  prefixIcon: Icon(Icons.exposure_plus_1),
                ),
                keyboardType: TextInputType.number,
                //validator: FormBuilderValidators.max(100),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.maxErrorText(100),
                  isRequired(isNum(lessThanOrEqualTo(100))),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Equal Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Equal Field',
                  prefixIcon: Icon(Icons.check),
                ),
                //validator: FormBuilderValidators.equal('test'),
                validator: isEqual('test'),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Contains Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contains "test"',
                  prefixIcon: Icon(Icons.search),
                ),
                //validator: FormBuilderValidators.contains('test'),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current
                      .containsErrorText('test'),
                  isRequired(contains('test')),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Match Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Match Pattern',
                  prefixIcon: Icon(Icons.pattern),
                ),
                //validator:
                //    FormBuilderValidators.match(RegExp(r'^[a-zA-Z0-9]+$')),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.matchErrorText,
                  isRequired(match(RegExp(r'^[a-zA-Z0-9]+$'))),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // IP Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'IP Field',
                  prefixIcon: Icon(Icons.computer),
                ),
                keyboardType: TextInputType.number,
                // validator: FormBuilderValidators.ip(),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.ipErrorText,
                  isRequired(ip()),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // UUID Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'UUID Field',
                  prefixIcon: Icon(Icons.code),
                ),
                //validator: FormBuilderValidators.uuid(),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.uuidErrorText,
                  isRequired(uuid()),
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Credit Card Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Credit Card Field',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                //validator: FormBuilderValidators.creditCard(),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.creditCardErrorText,
                  isRequired(creditCard()),
                ),
                autofillHints: const <String>[AutofillHints.creditCardNumber],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Phone Number Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number Field',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                //validator: FormBuilderValidators.phoneNumber(),
                validator: overrideErrorMsg(
                  (_) => FormBuilderLocalizations.current.phoneErrorText,
                  isRequired(phoneNumber()),
                ),
                autofillHints: const <String>[AutofillHints.telephoneNumber],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Password Validator
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password Field',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                //validator: FormBuilderValidators.password(),
                validator: isRequired(password()),
                autofillHints: const <String>[AutofillHints.password],
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.always,
              ),
              // Custom Validators Example
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Custom Age Validator',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                /*
                validator:
                    FormBuilderValidators.compose(<FormFieldValidator<String>>[
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                  FormBuilderValidators.max(120),
                ]),
               */
                validator: isRequired(isNum(
                    and([greaterThanOrEqualTo(0), lessThanOrEqualTo(120)]))),
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.always,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText:
                      '(optional) Choose a value that is either a num in the set: (-10,5] U {7, 8} U (100, +inf) or an even integer.',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: isOptional(or([
                  isNum(or([
                    and([greaterThan(-10), lessThanOrEqualTo(5)]),
                    isEqual(7),
                    isEqual(8),
                    greaterThan(100),
                  ])),
                  isInt(
                    (int value) =>
                        value % 2 == 0 ? null : 'The input must be even.',
                  ),
                ])),
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.always,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
