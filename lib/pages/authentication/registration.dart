import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/widgets/nm_box.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //// Controllers
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  //// Focus nodes
  FocusNode _firstnameFocus = FocusNode();
  FocusNode _surnameFocus = FocusNode();
  FocusNode _idFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  FocusNode _cityFocus = FocusNode();
  FocusNode _districtFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmFocus = FocusNode();
  FocusNode _countryFocus = FocusNode();

  int currentStep = 0;
  double stepHeight = 250.0;
  int numOfSteps = 4;
  bool isMale = false;
  bool isPrimaryDevice = true;
  Country _selectedCountry;

  void next() {
    setState(() {
      currentStep = (currentStep + 1) % numOfSteps;
    });
  }

  void cancel() {
    setState(() {
      currentStep = (currentStep - 1) % numOfSteps;
    });
  }

  void stepTap(value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget _buildGenderBar() {
    TextStyle _style = TextStyle(color: Colors.white);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                isMale = true;
              });
            },
            child: Text(
              "MALE",
              style: _style,
            ),
            color: isMale ? Colors.purple[300] : Colors.black.withOpacity(.5),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                isMale = false;
              });
            },
            child: Text(
              "FEMALE",
              style: _style,
            ),
            color: isMale ? Colors.black.withOpacity(.5) : Colors.purple[300],
          ),
        ),
      ],
    );
  }

  List<FAStep> _buildSteps() {
    print(currentStep);
    return [
      FAStep(
        //state: FAStepstate.indexed,
        title: Icon(FontAwesomeIcons.user),
        isActive: currentStep == 0,
        content: Container(
          height: stepHeight,
          child: Column(
            children: <Widget>[
              _SignUpField(
                hint: "firstname",
                icon: FontAwesomeIcons.user,
                node: _firstnameFocus,
                controller: _firstnameController,
                nextFocus: () {
                  nextFocus(_surnameFocus);
                },
              ),
              _SignUpField(
                hint: "Surname",
                icon: FontAwesomeIcons.user,
                node: _surnameFocus,
                controller: _surnameController,
                nextFocus: () {
                  nextFocus(_idFocus);
                },
              ),
              _buildGenderBar(),
              _SignUpField(
                hint: "ID",
                icon: FontAwesomeIcons.user,
                node: _idFocus,
                controller: _idController,
                nextFocus: () {
                  setState(() {
                    currentStep = 1;
                  });
                  nextFocus(_emailFocus);
                },
              )
            ],
          ),
        ),
      ),
      FAStep(
        isActive: currentStep == 1,
        title: Icon(FontAwesomeIcons.addressBook),
        content: Container(
          height: stepHeight,
          child: Column(
            children: <Widget>[
              _SignUpField(
                hint: "Email",
                controller: _emailController,
                node: _emailFocus,
                icon: FontAwesomeIcons.user,
                nextFocus: () {
                  nextFocus(_phoneFocus);
                },
              ),
              _buildPhoneField()
            ],
          ),
        ),
      ),
      FAStep(
        isActive: currentStep == 2,
        title: Icon(FontAwesomeIcons.locationArrow),
        content: Container(
          height: stepHeight,
          child: Column(
            children: <Widget>[
              _SignUpField(
                hint: "City/Town",
                controller: _cityController,
                node: _cityFocus,
                icon: FontAwesomeIcons.user,
                nextFocus: () {
                  nextFocus(_countryFocus);
                },
              ),
              _SignUpField(
                hint: "Country",
                icon: FontAwesomeIcons.user,
                controller: _countryController,
                node: _countryFocus,
                nextFocus: () {
                  nextFocus(_districtFocus);
                },
              ),
              _SignUpField(
                hint: "Province/District",
                icon: FontAwesomeIcons.user,
                controller: _districtController,
                node: _districtFocus,
                nextFocus: () {
                  setState(() {
                    currentStep = 3;
                  });
                  nextFocus(_passwordFocus);
                },
              ),
            ],
          ),
        ),
      ),
      FAStep(
        isActive: currentStep == 3,
        title: Icon(FontAwesomeIcons.lock),
        content: Container(
          height: stepHeight,
          child: Column(
            children: <Widget>[
              _SignUpField(
                hint: "Password",
                icon: FontAwesomeIcons.user,
                node: _passwordFocus,
                controller: _passwordController,
                nextFocus: () {
                  nextFocus(_confirmFocus);
                },
              ),
              _SignUpField(
                hint: "Confirm",
                icon: FontAwesomeIcons.user,
                controller: _confirmController,
                node: _cityFocus,
              ),
              _buildPrimaryDeviceField()
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildDialogItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: Text('Select your phone code'),
                onValuePicked: (Country country) =>
                    setState(() => _selectedCountry = country),
                //itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                priorityList: [
                  CountryPickerUtils.getCountryByIsoCode('TR'),
                  CountryPickerUtils.getCountryByIsoCode('US'),
                ],
                itemBuilder: _buildDialogItem)),
      );

  Widget _buildPhoneField() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.black.withOpacity(.5),
            child: FlatButton(
              child: Text(
                _selectedCountry?.phoneCode ?? "code",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _openCountryPickerDialog,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: _SignUpField(
            hint: 'Phone',
            icon: FontAwesomeIcons.phone,
            controller: _phoneController,
            node: _phoneFocus,
            nextFocus: () {
              setState(() {
                currentStep = 2;
              });
              nextFocus(_cityFocus);
            },
          ),
        ),
      ],
    );
  }

  Container _buildPrimaryDeviceField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.black.withOpacity(.4),
      child: ListTile(
        subtitle: Text(
          "SAMSUNG_J2E60",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        title: Text(
          "Is this your primary device?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        trailing: Switch(
            value: isPrimaryDevice,
            activeColor: Colors.purple,
            onChanged: (value) {
              setState(() {
                isPrimaryDevice = value;
              });
            }),
      ),
    );
  }

  void nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
    print("good");
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.w100,
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/back.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black.withOpacity(.5),
                    Colors.black.withOpacity(.8),
                  ],
                ),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: "Join Us!\n",
                        children: [
                          TextSpan(
                            text: "Gadget Security\n",
                            style: defaultStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 40,
                              // decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          TextSpan(
                            text: "Protect your device",
                            style: defaultStyle.copyWith(
                              fontSize: 25,
                            ),
                          )
                        ],
                        style: defaultStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      var velocity = details.primaryVelocity;
                      if (velocity > 0) {
                        next();
                      } else {
                        cancel();
                      }
                    },
                    child: Container(
                      height: 450,
                      child: FAStepper(
                        physics: BouncingScrollPhysics(),
                        type: FAStepperType.horizontal,
                        titleHeight: 80,
                        onStepContinue: next,
                        currentStep: currentStep,
                        onStepCancel: cancel,
                        onStepTapped: stepTap,
                        steps: _buildSteps(),
                        stepNumberColor: Colors.purpleAccent,
                        controlsBuilder: (BuildContext context,
                            {VoidCallback onStepContinue,
                            VoidCallback onStepCancel}) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: Colors.white,
                                onPressed: onStepCancel,
                                child: const Text('Back'),
                              ),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: Colors.white,
                                onPressed: onStepContinue,
                                child: currentStep == 3
                                    ? const Text('Save')
                                    : Text("Next"),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  // _buildSaveButton(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createAccount() {
    var firstname = _firstnameController.text;
    var surname = _surnameController.text;
    var gender = isMale;
    var id = _idController.text;
    var email = _emailController.text;
    var phone = "${_selectedCountry.phoneCode} ${_phoneController.text}";
    var cityTown = _cityController.text;
    var country = _countryController.text;
    var district = _districtController.text;
    var password = _passwordController.text;
    var savePrimaryDevice = isPrimaryDevice;
  }

  Container _buildSaveButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: nMbox.copyWith(boxShadow: []),
      child: FlatButton(
        onPressed: () {},
        child: Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SignUpField extends StatelessWidget {
  const _SignUpField({
    Key key,
    this.controller,
    this.hint,
    this.validator,
    this.icon,
    this.node,
    this.nextFocus,
  }) : super(key: key);

  final TextEditingController controller;
  final VoidCallback nextFocus;
  final String hint;
  final VoidCallback validator;
  final IconData icon;
  final FocusNode node;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        controller: controller,
        focusNode: node,
        textInputAction: null == node
            ? TextInputAction.continueAction
            : TextInputAction.next,
        onSubmitted: (text) {
          nextFocus();
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(.4),
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          hintText: "$hint",
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: Container(
            width: 10,
            height: 10,
            //color: Colors.black.withOpacity(.5),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
