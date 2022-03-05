import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper_app/models/forms.dart';
import 'package:meetuper_app/screens/meetup_detail_screen.dart';
import 'package:meetuper_app/screens/meetup_home_screen.dart';
import 'package:meetuper_app/services/meetup_api_service.dart';
import 'package:meetuper_app/models/category.dart';
import 'package:intl/intl.dart';
import 'package:meetuper_app/utils/generate_times.dart';
import 'package:meetuper_app/widgets/select_input.dart';

class MeetupCreateScreen extends StatefulWidget {
  static final String route = '/meetupCreate';

  MeetupCreateScreenState createState() => MeetupCreateScreenState();
}

class MeetupCreateScreenState extends State<MeetupCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext? _scaffoldContext;

  MeetupFormData _meetupFormData = MeetupFormData();
  MeetupApiService _api = MeetupApiService();
  List<userCategory> _categories = [];
  final List<String> _times = generateTimes();

  @override
  initState() {
    _api.fetchCategories().then((categories) => setState(() => _categories = categories));

    super.initState();
  }

  _handleDateChange(DateTime selectedDate) {
    _meetupFormData.startDate = selectedDate;
  }

  // _handleTimeFromChange(String time) {
  //   _meetupFormData.timeFrom = time;
  // }

  // _handleTimeToChange(String time) {
  //   _meetupFormData.timeTo = time;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Create Meetup')),
        body: Builder(builder: (context) {
          _scaffoldContext = context;
          return Padding(padding: const EdgeInsets.all(10.0), child: _buildForm());
        }));
  }

  // void handleSuccesfulCreate(dynamic data) async {
  //   // await Navigator
  //   //   .pushNamed(context, "/login",
  //   //              arguments: LoginScreenArguments('You have been succesfuly logged in!'));
  // }

  // void handleError(String message) {
  //   Scaffold.of(_scaffoldContext!).showSnackBar(SnackBar(content: Text(message)));
  // }

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _api.createMeetup(_meetupFormData)
        .then((String? meetupId) {
          Navigator
            .pushNamedAndRemoveUntil(
              context,
              MeetupDetailScreen.route,
              ModalRoute.withName('/homescreen'),
              arguments: MeetupDetailArguments(id: meetupId!));
        })
        .catchError((e) => print(e));
    }
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTitle(),
            TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              decoration: const InputDecoration(
                hintText: 'Location',
              ),
              onSaved: (value) => _meetupFormData.location = value!,
            ),
            TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
              onSaved: (value) => _meetupFormData.title = value!,
            ),
            _DatePicker(onDateChange: _handleDateChange),
            SelectInput<userCategory>(
                items: _categories,
                onChange: (userCategory c) => _meetupFormData.category = c,
                label: 'Category'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Image',
              ),
              onSaved: (value) => _meetupFormData.image = value!,
            ),
            TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              decoration: const InputDecoration(
                hintText: 'Short Info',
              ),
              onSaved: (value) => _meetupFormData.shortInfo = value!,
            ),
            TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(300)],
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSaved: (value) => _meetupFormData.description = value!,
            ),
            SelectInput<String>(
                items: _times,
                onChange: (String t) => _meetupFormData.timeFrom = t,
                label: 'Time From'),
            SelectInput<String>(
                items: _times,
                onChange: (String t) => _meetupFormData.timeTo = t,
                label: 'Time To'),
            const SizedBox(
              height: 20,
            ),
            _buildSubmitBtn()
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: const Text('Create Awesome Meetup',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  Widget _buildSubmitBtn() {
    return ElevatedButton(
      child: const Text('Submit'),
      onPressed: _submitCreate,
    );
  }
}

// class _CategorySelect extends StatelessWidget {
//   final List<userCategory> categories;
//   final MeetupFormData meetupFormData;

//   _CategorySelect({required this.categories, required this.meetupFormData});

//   Widget build(BuildContext context) {
//     return FormField<userCategory>(
//       builder: (FormFieldState<userCategory> state) {
//         return InputDecorator(
//           decoration: const InputDecoration(
//             icon: Icon(Icons.color_lens),
//             labelText: 'Category',
//           ),
//           isEmpty: meetupFormData.category == null,
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<userCategory>(
//               value: meetupFormData.category,
//               isDense: true,
//               onChanged: (userCategory? newCategory) {
//                 meetupFormData.category = newCategory;
//                 state.didChange(newCategory);
//               },
//               items: categories.map((userCategory category) {
//                 return DropdownMenuItem<userCategory>(
//                   value: category,
//                   child: Text(category.name),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class _DatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;

  _DatePicker({required this.onDateChange});

  @override
  __DatePickerState createState() => __DatePickerState();
}

class __DatePickerState extends State<_DatePicker> {
  DateTime _dateNow = DateTime.now();
  DateTime _initialDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: _dateNow,
        lastDate: DateTime(_dateNow.year + 1, _dateNow.month, _dateNow.day));
    if (picked != null && picked != _initialDate) {
      widget.onDateChange(picked);
      setState(() {
        _dateController.text = _dateFormat.format(picked);
        _initialDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today),
          hintText: 'Enter date when meetup starts',
          labelText: 'Dob',
        ),
        controller: _dateController,
        keyboardType: TextInputType.datetime,
      )),
      IconButton(
        icon: const Icon(Icons.more_horiz),
        tooltip: 'Choose date',
        onPressed: (() {
          _selectDate(context);
        }),
      )
    ]);
  }
}

// class _TimeSelect extends StatefulWidget {
//   _TimeSelectState createState() => _TimeSelectState();
//   final Function(String) onTimeChange;
//   final label;

//   final List<String> times = generateTimes();
//   _TimeSelect({required this.onTimeChange, this.label});
// }

// class _TimeSelectState extends State<_TimeSelect> {
//   String? _selectedTime;

//   Widget build(BuildContext context) {
//     return FormField<String>(
//       builder: (FormFieldState<String> state) {
//         return InputDecorator(
//           decoration: InputDecoration(
//             icon: const Icon(Icons.timer),
//             labelText: widget.label ?? 'Time',
//           ),
//           isEmpty: _selectedTime == null,
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedTime,
//               isDense: true,
//               onChanged: (String? newTime) {
//                 widget.onTimeChange(newTime!);
//                 _selectedTime = newTime;
//                 state.didChange(newTime);
//               },
//               items: widget.times.map((String time) {
//                 {
//                   return DropdownMenuItem<String>(
//                     value: time,
//                     child: Text(time),
//                   );
//                 }
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
  // }
// }
