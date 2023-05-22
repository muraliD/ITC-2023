// ignore_for_file: avoid_print


import 'package:flutter/material.dart';

import 'package:itc_community/data/preferences.dart';

import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/my_colors.dart';
import 'package:itc_community/models/registration_response.dart';


import 'package:itc_community/services//repository.dart';
class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  TextEditingController refController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController newPassController = TextEditingController(text: '');
  TextEditingController cNewpassController = TextEditingController(text: '');

  var username, password,cpassword,email,ref;
  bool passenablen = true;
  bool passenablecn = true;
  var  npassword, cnpassword;
  //  _formKey and _autoValidate
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var agree = false;
  String selectedValue = "91"+"Text"+"India";
  String _selectedText = "SSD";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Select Country"), value: "Select Country"),
      DropdownMenuItem(child: Text("Afghanistan"), value: "93"+"Text"+"Afghanistan"),
      DropdownMenuItem(child: Text("Aland Islands"), value: "358"+"Text"+"Aland Islands"),
      DropdownMenuItem(child: Text("Albania"), value: "355"+"Text"+"Albania"),
      DropdownMenuItem(child: Text("Algeria"), value: "213"+"Text"+"Algeria"),
      DropdownMenuItem(child: Text("American Samoa"), value: "1684"+"Text"+"American Samoa"),
      DropdownMenuItem(child: Text("Andorra"), value: "376"+"Text"+"Andorra"),
      DropdownMenuItem(child: Text("Angola"), value: "244"+"Text"+"Angola"),
      DropdownMenuItem(child: Text("Anguilla"), value: "1264"+"Text"+"Anguilla"),
      DropdownMenuItem(child: Text("Antarctica"), value: "672"+"Text"+"Antarctica"),
      DropdownMenuItem(child: Text("Antigua and Barbuda"), value: "1268"+"Text"+"Antigua and Barbuda"),
      DropdownMenuItem(child: Text("Argentina"), value: "54"+"Text"+"Argentina"),
      DropdownMenuItem(child: Text("Armenia"), value: "374"+"Text"+"Armenia"),
      DropdownMenuItem(child: Text("Aruba"), value: "297"+"Text"+"Aruba"),
      DropdownMenuItem(child: Text("Australia"), value: "61"+"Text"+"Australia"),
      DropdownMenuItem(child: Text("Austria"), value: "43"+"Text"+"Austria"),
      DropdownMenuItem(child: Text("Azerbaijan"), value: "994"+"Text"+"Azerbaijan"),
      DropdownMenuItem(child: Text("Bahamas"), value: "1242"+"Text"+"Bahamas"),
      DropdownMenuItem(child: Text("Bahrain"), value: "973"+"Text"+"Bahrain"),
      DropdownMenuItem(child: Text("Bangladesh"), value: "880"+"Text"+"Bangladesh"),
      DropdownMenuItem(child: Text("Barbados"), value: "1246"+"Text"+"Barbados"),
      DropdownMenuItem(child: Text("Belarus"), value: "375"+"Text"+"Belarus"),
      DropdownMenuItem(child: Text("Belgium"), value: "32"+"Text"+"Belgium"),
      DropdownMenuItem(child: Text("Belize"), value: "501"+"Text"+"Belize"),
      DropdownMenuItem(child: Text("Benin"), value: "229"+"Text"+"Benin"),
      DropdownMenuItem(child: Text("Bermuda"), value: "1441"+"Text"+"Bermuda"),
      DropdownMenuItem(child: Text("Bhutan"), value: "975"+"Text"+"Bhutan"),
      DropdownMenuItem(child: Text("Bolivia"), value: "591"+"Text"+"Bolivia"),
      DropdownMenuItem(child: Text("Bonaire, Sint Eustatius and Saba"), value: "599"+"Text"+"Bonaire, Sint Eustatius and Saba"),
      DropdownMenuItem(child: Text("Bosnia and Herzegovina"), value: "387"+"Text"+"Bosnia and Herzegovina"),
      DropdownMenuItem(child: Text("Botswana"), value: "267"+"Text"+"Botswana"),
      DropdownMenuItem(child: Text("Bouvet Island"), value: "55"+"Text"+"Bouvet Island"),
      DropdownMenuItem(child: Text("Brazil"), value: "55"+"Text"+"Brazil"),
      DropdownMenuItem(child: Text("British Indian Ocean Territory"), value: "246"+"Text"+"British Indian Ocean Territory"),
      DropdownMenuItem(child: Text("Brunei Darussalam"), value: "673"+"Text"+"Brunei Darussalam"),
      DropdownMenuItem(child: Text("Bulgaria"), value: "359"+"Text"+"Bulgaria"),
      DropdownMenuItem(child: Text("Burkina Faso"), value: "226"+"Text"+"Burkina Faso"),
      DropdownMenuItem(child: Text("Burundi"), value: "257"+"Text"+"Burundi"),
      DropdownMenuItem(child: Text("Cambodia"), value: "855"+"Text"+"Cambodia"),
      DropdownMenuItem(child: Text("Cameroon"), value: "237"+"Text"+"Cameroon"),
      DropdownMenuItem(child: Text("Canada"), value: "1"+"Text"+"Canada"),
      DropdownMenuItem(child: Text("Cape Verde"), value: "238"+"Text"+"Cape Verde"),
      DropdownMenuItem(child: Text("Cayman Islands"), value: "1345"+"Text"+"Cayman Islands"),
      DropdownMenuItem(child: Text("Central African Republic"), value: "236"+"Text"+"Central African Republic"),
      DropdownMenuItem(child: Text("Chad"), value: "235"+"Text"+"Chad"),
      DropdownMenuItem(child: Text("Chile"), value: "56"+"Text"+"Chile"),
      DropdownMenuItem(child: Text("China"), value: "86"+"Text"+"China"),
      DropdownMenuItem(child: Text("Christmas Island"), value: "61"+"Text"+"Christmas Island"),
      DropdownMenuItem(child: Text("Cocos (Keeling) Islands"), value: "672"+"Text"+"Cocos (Keeling) Islands"),
      DropdownMenuItem(child: Text("Colombia"), value: "57"+"Text"+"Colombia"),
      DropdownMenuItem(child: Text("Comoros"), value: "269"+"Text"+"Comoros"),
      DropdownMenuItem(child: Text("Congo"), value: "242"+"Text"+"Congo"),
      DropdownMenuItem(child: Text("Congo, Democratic Republic of the Congo"), value: "242"+"Text"+"Congo, Democratic Republic of the Congo"),
      DropdownMenuItem(child: Text("Cook Islands"), value: "682"+"Text"+"Cook Islands"),
      DropdownMenuItem(child: Text("Costa Rica"), value: "506"+"Text"+"Costa Rica"),
      DropdownMenuItem(child: Text("Cote D'Ivoire"), value: "225"+"Text"+"Cote D'Ivoire"),
      DropdownMenuItem(child: Text("Croatia"), value: "385"+"Text"+"Croatia"),
      DropdownMenuItem(child: Text("Cuba"), value: "53"+"Text"+"Cuba"),
      DropdownMenuItem(child: Text("Curacao"), value: "599"+"Text"+"Curacao"),
      DropdownMenuItem(child: Text("Cyprus"), value: "357"+"Text"+"Cyprus"),
      DropdownMenuItem(child: Text("Czech Republic"), value: "420"+"Text"+"Czech Republic"),
      DropdownMenuItem(child: Text("Denmark"), value: "45"+"Text"+"Denmark"),
      DropdownMenuItem(child: Text("Djibouti"), value: "253"+"Text"+"Djibouti"),
      DropdownMenuItem(child: Text("Dominica"), value: "1767"+"Text"+"Dominica"),
      DropdownMenuItem(child: Text("Dominican Republic"), value: "1809"+"Text"+"Dominican Republic"),
      DropdownMenuItem(child: Text("Ecuador"), value: "593"+"Text"+"Ecuador"),
      DropdownMenuItem(child: Text("Egypt"), value: "20"+"Text"+"Egypt"),
      DropdownMenuItem(child: Text("El Salvador"), value: "503"+"Text"+"El Salvador"),
      DropdownMenuItem(child: Text("Equatorial Guinea"), value: "240"+"Text"+"Equatorial Guinea"),
      DropdownMenuItem(child: Text("Eritrea"), value: "291"+"Text"+"Eritrea"),
      DropdownMenuItem(child: Text("Estonia"), value: "372"+"Text"+"Estonia"),
      DropdownMenuItem(child: Text("Ethiopia"), value: "251"+"Text"+"Ethiopia"),
      DropdownMenuItem(child: Text("Falkland Islands (Malvinas"), value: "500"+"Text"+"Falkland Islands (Malvinas"),
      DropdownMenuItem(child: Text("Faroe Islands"), value: "298"+"Text"+"Faroe Islands"),
      DropdownMenuItem(child: Text("Fiji"), value: "679"+"Text"+"Fiji"),
      DropdownMenuItem(child: Text("Finland"), value: "358"+"Text"+"Finland"),
      DropdownMenuItem(child: Text("France"), value: "33"+"Text"+"France"),
      DropdownMenuItem(child: Text("French Guiana"), value: "594"+"Text"+"French Guiana"),
      DropdownMenuItem(child: Text("French Polynesia"), value: "689"+"Text"+"French Polynesia"),
      DropdownMenuItem(child: Text("French Southern Territories"), value: "262"+"Text"+"French Southern Territories"),
      DropdownMenuItem(child: Text("Gabon"), value: "241"+"Text"+"Gabon"),
      DropdownMenuItem(child: Text("Gambia"), value: "220"+"Text"+"Gambia"),
      DropdownMenuItem(child: Text("Georgia"), value: "995"+"Text"+"Georgia"),
      DropdownMenuItem(child: Text("Germany"), value: "49"+"Text"+"Germany"),
      DropdownMenuItem(child: Text("Ghana"), value: "233"+"Text"+"Ghana"),
      DropdownMenuItem(child: Text("Gibraltar"), value: "350"+"Text"+"Gibraltar"),
      DropdownMenuItem(child: Text("Greece"), value: "30"+"Text"+"Greece"),
      DropdownMenuItem(child: Text("Greenland"), value: "299"+"Text"+"Greenland"),
      DropdownMenuItem(child: Text("Grenada"), value: "1473"+"Text"+"Grenada"),
      DropdownMenuItem(child: Text("Guadeloupe"), value: "590"+"Text"+"Guadeloupe"),
      DropdownMenuItem(child: Text("Guam"), value: "1671"+"Text"+"Guam"),
      DropdownMenuItem(child: Text("Guatemala"), value: "502"+"Text"+"Guatemala"),
      DropdownMenuItem(child: Text("Guernsey"), value: "44"+"Text"+"Guernsey"),
      DropdownMenuItem(child: Text("Guinea"), value: "224"+"Text"+"Guinea"),
      DropdownMenuItem(child: Text("Guinea-Bissau"), value: "245"+"Text"+"Guinea-Bissau"),
      DropdownMenuItem(child: Text("Guyana"), value: "592"+"Text"+"Guyana"),
      DropdownMenuItem(child: Text("Haiti"), value: "509"+"Text"+"Haiti"),
      DropdownMenuItem(child: Text("Heard Island and Mcdonald Islands"), value: "0"+"Text"+"Heard Island and Mcdonald Islands"),
      DropdownMenuItem(child: Text("Holy See (Vatican City State"), value: "379"+"Text"+"Holy See (Vatican City State"),
      DropdownMenuItem(child: Text("Honduras"), value: "504"+"Text"+"Honduras"),
      DropdownMenuItem(child: Text("Hong Kong"), value: "852"+"Text"+"Hong Kong"),
      DropdownMenuItem(child: Text("Hungary"), value: "36"+"Text"+"Hungary"),
      DropdownMenuItem(child: Text("Iceland"), value: "354"+"Text"+"Iceland"),
      DropdownMenuItem(child: Text("India"), value: "91"+"Text"+"India"),
      DropdownMenuItem(child: Text("Indonesia"), value: "62"+"Text"+"Indonesia"),
      DropdownMenuItem(child: Text("Iran, Islamic Republic of"), value: "98"+"Text"+"Iran, Islamic Republic of"),
      DropdownMenuItem(child: Text("Iraq"), value: "964"+"Text"+"Iraq"),
      DropdownMenuItem(child: Text("Ireland"), value: "353"+"Text"+"Ireland"),
      DropdownMenuItem(child: Text("Isle of Man"), value: "44"+"Text"+"Isle of Man"),
      DropdownMenuItem(child: Text("Israel"), value: "972"+"Text"+"Israel"),
      DropdownMenuItem(child: Text("Italy"), value: "39"+"Text"+"Italy"),
      DropdownMenuItem(child: Text("Jamaica"), value: "1876"+"Text"+"Jamaica"),
      DropdownMenuItem(child: Text("Japan"), value: "81"+"Text"+"Japan"),
      DropdownMenuItem(child: Text("Jersey"), value: "44"+"Text"+"Jersey"),
      DropdownMenuItem(child: Text("Jordan"), value: "962"+"Text"+"Jordan"),
      DropdownMenuItem(child: Text("Kazakhstan"), value: "7"+"Text"+"Kazakhstan"),
      DropdownMenuItem(child: Text("Kenya"), value: "254"+"Text"+"Kenya"),
      DropdownMenuItem(child: Text("Kiribati"), value: "686"+"Text"+"Kiribati"),
      DropdownMenuItem(child: Text("Korea, Democratic People's Republic of"), value: "850"+"Text"+"Korea, Democratic People's Republic of"),
      DropdownMenuItem(child: Text("Korea, Republic of"), value: "82"+"Text"+"Korea, Republic of"),
      DropdownMenuItem(child: Text("Kosovo"), value: "381"+"Text"+"Kosovo"),
      DropdownMenuItem(child: Text("Kuwait"), value: "965"+"Text"+"Kuwait"),
      DropdownMenuItem(child: Text("Kyrgyzstan"), value: "996"+"Text"+"Kyrgyzstan"),
      DropdownMenuItem(child: Text("Lao People's Democratic Republic"), value: "856"+"Text"+"Lao People's Democratic Republic"),
      DropdownMenuItem(child: Text("Latvia"), value: "371"+"Text"+"Latvia"),
      DropdownMenuItem(child: Text("Lebanon"), value: "961"+"Text"+"Lebanon"),
      DropdownMenuItem(child: Text("Lesotho"), value: "266"+"Text"+"Lesotho"),
      DropdownMenuItem(child: Text("Liberia"), value: "231"+"Text"+"Liberia"),
      DropdownMenuItem(child: Text("Libyan Arab Jamahiriya"), value: "218"+"Text"+"Libyan Arab Jamahiriya"),
      DropdownMenuItem(child: Text("Liechtenstein"), value: "423"+"Text"+"Liechtenstein"),
      DropdownMenuItem(child: Text("Lithuania"), value: "370"+"Text"+"Lithuania"),
      DropdownMenuItem(child: Text("Luxembourg"), value: "352"+"Text"+"Luxembourg"),
      DropdownMenuItem(child: Text("Macao"), value: "853"+"Text"+"Macao"),
      DropdownMenuItem(child: Text("Macedonia, the Former Yugoslav Republic of"), value: "389"+"Text"+"Macedonia, the Former Yugoslav Republic of"),
      DropdownMenuItem(child: Text("Madagascar"), value: "261"+"Text"+"Madagascar"),
      DropdownMenuItem(child: Text("Malawi"), value: "265"+"Text"+"Malawi"),
      DropdownMenuItem(child: Text("Malaysia"), value: "60"+"Text"+"Malaysia"),
      DropdownMenuItem(child: Text("Maldives"), value: "960"+"Text"+"Maldives"),
      DropdownMenuItem(child: Text("Mali"), value: "223"+"Text"+"Mali"),
      DropdownMenuItem(child: Text("Malta"), value: "356"+"Text"+"Malta"),
      DropdownMenuItem(child: Text("Marshall Islands"), value: "692"+"Text"+"Marshall Islands"),
      DropdownMenuItem(child: Text("Martinique"), value: "596"+"Text"+"Martinique"),
      DropdownMenuItem(child: Text("Mauritania"), value: "222"+"Text"+"Mauritania"),
      DropdownMenuItem(child: Text("Mauritius"), value: "230"+"Text"+"Mauritius"),
      DropdownMenuItem(child: Text("Mayotte"), value: "269"+"Text"+"Mayotte"),
      DropdownMenuItem(child: Text("Mexico"), value: "52"+"Text"+"Mexico"),
      DropdownMenuItem(child: Text("Micronesia, Federated States of"), value: "691"+"Text"+"Micronesia, Federated States of"),
      DropdownMenuItem(child: Text("Moldova, Republic of"), value: "373"+"Text"+"Moldova, Republic of"),
      DropdownMenuItem(child: Text("Monaco"), value: "377"+"Text"+"Monaco"),
      DropdownMenuItem(child: Text("Mongolia"), value: "976"+"Text"+"Mongolia"),
      DropdownMenuItem(child: Text("Montenegro"), value: "382"+"Text"+"Montenegro"),
      DropdownMenuItem(child: Text("Montserrat"), value: "1664"+"Text"+"Montserrat"),
      DropdownMenuItem(child: Text("Morocco"), value: "212"+"Text"+"Morocco"),
      DropdownMenuItem(child: Text("Mozambique"), value: "258"+"Text"+"Mozambique"),
      DropdownMenuItem(child: Text("Myanmar"), value: "95"+"Text"+"Myanmar"),
      DropdownMenuItem(child: Text("Namibia"), value: "264"+"Text"+"Namibia"),
      DropdownMenuItem(child: Text("Nauru"), value: "674"+"Text"+"Nauru"),
      DropdownMenuItem(child: Text("Nepal"), value: "977"+"Text"+"Nepal"),
      DropdownMenuItem(child: Text("Netherlands"), value: "31"+"Text"+"Netherlands"),
      DropdownMenuItem(child: Text("Netherlands Antilles"), value: "599"+"Text"+"Netherlands Antilles"),
      DropdownMenuItem(child: Text("New Caledonia"), value: "687"+"Text"+"New Caledonia"),
      DropdownMenuItem(child: Text("New Zealand"), value: "64"+"Text"+"New Zealand"),
      DropdownMenuItem(child: Text("Nicaragua"), value: "505"+"Text"+"Nicaragua"),
      DropdownMenuItem(child: Text("Niger"), value: "227"+"Text"+"Niger"),
      DropdownMenuItem(child: Text("Nigeria"), value: "234"+"Text"+"Nigeria"),
      DropdownMenuItem(child: Text("Niue"), value: "683"+"Text"+"Niue"),
      DropdownMenuItem(child: Text("Norfolk Island"), value: "672"+"Text"+"Norfolk Island"),
      DropdownMenuItem(child: Text("Northern Mariana Islands"), value: "1670"+"Text"+"Northern Mariana Islands"),
      DropdownMenuItem(child: Text("Norway"), value: "47"+"Text"+"Norway"),
      DropdownMenuItem(child: Text("Oman"), value: "968"+"Text"+"Oman"),
      DropdownMenuItem(child: Text("Pakistan"), value: "92"+"Text"+"Pakistan"),
      DropdownMenuItem(child: Text("Palau"), value: "680"+"Text"+"Palau"),
      DropdownMenuItem(child: Text("Palestinian Territory, Occupied"), value: "970"+"Text"+"Palestinian Territory, Occupied"),
      DropdownMenuItem(child: Text("Panama"), value: "507"+"Text"+"Panama"),
      DropdownMenuItem(child: Text("Papua New Guinea"), value: "675"+"Text"+"Papua New Guinea"),
      DropdownMenuItem(child: Text("Paraguay"), value: "595"+"Text"+"Paraguay"),
      DropdownMenuItem(child: Text("Peru"), value: "51"+"Text"+"Peru"),
      DropdownMenuItem(child: Text("Philippines"), value: "63"+"Text"+"Philippines"),
      DropdownMenuItem(child: Text("Pitcairn"), value: "64"+"Text"+"Pitcairn"),
      DropdownMenuItem(child: Text("Poland"), value: "48"+"Text"+"Poland"),
      DropdownMenuItem(child: Text("Portugal"), value: "351"+"Text"+"Portugal"),
      DropdownMenuItem(child: Text("Puerto Rico"), value: "1787"+"Text"+"Puerto Rico"),
      DropdownMenuItem(child: Text("Qatar"), value: "974"+"Text"+"Qatar"),
      DropdownMenuItem(child: Text("Reunion"), value: "262"+"Text"+"Reunion"),
      DropdownMenuItem(child: Text("Romania"), value: "40"+"Text"+"Romania"),
      DropdownMenuItem(child: Text("Russian Federation"), value: "70"+"Text"+"Russian Federation"),
      DropdownMenuItem(child: Text("Rwanda"), value: "250"+"Text"+"Rwanda"),
      DropdownMenuItem(child: Text("Saint Barthelemy"), value: "590"+"Text"+"Saint Barthelemy"),
      DropdownMenuItem(child: Text("Saint Helena"), value: "290"+"Text"+"Saint Helena"),
      DropdownMenuItem(child: Text("Saint Kitts and Nevis"), value: "1869"+"Text"+"Saint Kitts and Nevis"),
      DropdownMenuItem(child: Text("Saint Lucia"), value: "1758"+"Text"+"Saint Lucia"),
      DropdownMenuItem(child: Text("Saint Martin"), value: "590"+"Text"+"Saint Martin"),
      DropdownMenuItem(child: Text("Saint Pierre and Miquelon"), value: "508"+"Text"+"Saint Pierre and Miquelon"),
      DropdownMenuItem(child: Text("Saint Vincent and the Grenadines"), value: "1784"+"Text"+"Saint Vincent and the Grenadines"),
      DropdownMenuItem(child: Text("Samoa"), value: "684"+"Text"+"Samoa"),
      DropdownMenuItem(child: Text("San Marino"), value: "378"+"Text"+"San Marino"),
      DropdownMenuItem(child: Text("Sao Tome and Principe"), value: "239"+"Text"+"Sao Tome and Principe"),
      DropdownMenuItem(child: Text("Saudi Arabia"), value: "966"+"Text"+"Saudi Arabia"),
      DropdownMenuItem(child: Text("Senegal"), value: "221"+"Text"+"Senegal"),
      DropdownMenuItem(child: Text("Serbia"), value: "381"+"Text"+"Serbia"),
      DropdownMenuItem(child: Text("Serbia and Montenegro"), value: "381"+"Text"+"Serbia and Montenegro"),
      DropdownMenuItem(child: Text("Seychelles"), value: "248"+"Text"+"Seychelles"),
      DropdownMenuItem(child: Text("Sierra Leone"), value: "232"+"Text"+"Sierra Leone"),
      DropdownMenuItem(child: Text("Singapore"), value: "65"+"Text"+"Singapore"),
      DropdownMenuItem(child: Text("Sint Maarten"), value: "1"+"Text"+"Sint Maarten"),
      DropdownMenuItem(child: Text("Slovakia"), value: "421"+"Text"+"Slovakia"),
      DropdownMenuItem(child: Text("Slovenia"), value: "386"+"Text"+"Slovenia"),
      DropdownMenuItem(child: Text("Solomon Islands"), value: "677"+"Text"+"Solomon Islands"),
      DropdownMenuItem(child: Text("Somalia"), value: "252"+"Text"+"Somalia"),
      DropdownMenuItem(child: Text("South Africa"), value: "27"+"Text"+"South Africa"),
      DropdownMenuItem(child: Text("South Georgia and the South Sandwich Islands"), value: "500"+"Text"+"South Georgia and the South Sandwich Islands"),
      DropdownMenuItem(child: Text("South Sudan"), value: "211"+"Text"+"South Sudan"),
      DropdownMenuItem(child: Text("Spain"), value: "34"+"Text"+"Spain"),
      DropdownMenuItem(child: Text("Sri Lanka"), value: "94"+"Text"+"Sri Lanka"),
      DropdownMenuItem(child: Text("Sudan"), value: "249"+"Text"+"Sudan"),
      DropdownMenuItem(child: Text("Suriname"), value: "597"+"Text"+"Suriname"),
      DropdownMenuItem(child: Text("Svalbard and Jan Mayen"), value: "47"+"Text"+"Svalbard and Jan Mayen"),
      DropdownMenuItem(child: Text("Swaziland"), value: "268"+"Text"+"Swaziland"),
      DropdownMenuItem(child: Text("Sweden"), value: "46"+"Text"+"Sweden"),
      DropdownMenuItem(child: Text("Switzerland"), value: "41"+"Text"+"Switzerland"),
      DropdownMenuItem(child: Text("Syrian Arab Republic"), value: "963"+"Text"+"Syrian Arab Republic"),
      DropdownMenuItem(child: Text("Taiwan, Province of China"), value: "886"+"Text"+"Taiwan, Province of China"),
      DropdownMenuItem(child: Text("Tajikistan"), value: "992"+"Text"+"Tajikistan"),
      DropdownMenuItem(child: Text("Tanzania, United Republic of"), value: "255"+"Text"+"Tanzania, United Republic of"),
      DropdownMenuItem(child: Text("Thailand"), value: "66"+"Text"+"Thailand"),
      DropdownMenuItem(child: Text("Timor-Leste"), value: "670"+"Text"+"Timor-Leste"),
      DropdownMenuItem(child: Text("Togo"), value: "228"+"Text"+"Togo"),
      DropdownMenuItem(child: Text("Tokelau"), value: "690"+"Text"+"Tokelau"),
      DropdownMenuItem(child: Text("Tonga"), value: "676"+"Text"+"Tonga"),
      DropdownMenuItem(child: Text("Trinidad and Tobago"), value: "1868"+"Text"+"Trinidad and Tobago"),
      DropdownMenuItem(child: Text("Tunisia"), value: "216"+"Text"+"Tunisia"),
      DropdownMenuItem(child: Text("Turkey"), value: "90"+"Text"+"Turkey"),
      DropdownMenuItem(child: Text("Turkmenistan"), value: "7370"+"Text"+"Turkmenistan"),
      DropdownMenuItem(child: Text("Turks and Caicos Islands"), value: "1649"+"Text"+"Turks and Caicos Islands"),
      DropdownMenuItem(child: Text("Tuvalu"), value: "688"+"Text"+"Tuvalu"),
      DropdownMenuItem(child: Text("Uganda"), value: "256"+"Text"+"Uganda"),
      DropdownMenuItem(child: Text("Ukraine"), value: "380"+"Text"+"Ukraine"),
      DropdownMenuItem(child: Text("United Arab Emirates"), value: "971"+"Text"+"United Arab Emirates"),
      DropdownMenuItem(child: Text("United Kingdom"), value: "44"+"Text"+"United Kingdom"),
      DropdownMenuItem(child: Text("United States"), value: "1"+"Text"+"United States"),
      DropdownMenuItem(child: Text("United States Minor Outlying Islands"), value: "1"+"Text"+"United States Minor Outlying Islands"),
      DropdownMenuItem(child: Text("Uruguay"), value: "598"+"Text"+"Uruguay"),
      DropdownMenuItem(child: Text("Uzbekistan"), value: "998"+"Text"+"Uzbekistan"),
      DropdownMenuItem(child: Text("Vanuatu"), value: "678"+"Text"+"Vanuatu"),
      DropdownMenuItem(child: Text("Venezuela"), value: "58"+"Text"+"Venezuela"),
      DropdownMenuItem(child: Text("Viet Nam"), value: "84"+"Text"+"Viet Nam"),
      DropdownMenuItem(child: Text("Virgin Islands, British"), value: "1284"+"Text"+"Virgin Islands, British"),
      DropdownMenuItem(child: Text("Virgin Islands, U.s"), value: "1340"+"Text"+"Virgin Islands, U.s"),
      DropdownMenuItem(child: Text("Wallis an Futuna"), value: "681"+"Text"+"Wallis an Futuna"),
      DropdownMenuItem(child: Text("Western Sahara"), value: "212"+"Text"+"Western Sahara"),
      DropdownMenuItem(child: Text("Yemen"), value: "967"+"Text"+"Yemen"),
      DropdownMenuItem(child: Text("Zambia"), value: "260"+"Text"+"Zambia"),
      DropdownMenuItem(child: Text("Zimbabwe"), value: "263"+"Text"+"Zimbabwe")

    ];

    return menuItems;
  }
resetForm(){

    setState(() {
      nameController.text = "";
      refController.text = "";
      selectedValue = "91"+"Text"+"India";
      countryController.text = "";
      emailController.text = "";
      cNewpassController.text = "";
      newPassController.text = "";
      agree=false;

    });




}

  @override
  void initState() {
    super.initState();
    Preferences.initSharedPreference();
  }

  void navigateToRegister() {


    // Navigator.of(context).pushReplacementNamed(
    //   Config.splashRouteName,
    // );
  }

  void _submit() {


    final isValid = _formKey.currentState?.validate();

    if (isValid == false) {
      return;
    }
    if(!agree){
      UtilClass.showAlertDialog(
          context: context,
          message:"Please Agree Terms & policy "
      );
      return;
    }
    _formKey.currentState?.save();

    callRegisterAPI();
  }
  void callRegisterAPI() async {

    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Repository.register(refcode: refController.text.length>0?refController.text:"609b80bcefe92", name: nameController.text, countryCode: selectedValue.split("Text")[0], mobile: countryController.text, email: emailController.text, password: newPassController.text, cpassword: cNewpassController.text, term: agree?"1":"0").then((value) {

        RegistrationResponse response = value;
        UtilClass.hideProgress(context: context);

        if((response.status!.type == "Success") || (response.status!.type == "pending")){

          UtilClass.showAlertDialog(
            context: context,
            message: response.status!.message??"Server Error",
            onOkClick: (()=>{

              resetForm()


            })
          );




        }else{
          UtilClass.showAlertDialog(
            context: context,
            message: response.status!.message??"Server Error"
          );

        }


        // if (value == Config.emailPasswordInvalid) {
        //   UtilClass.showAlertDialog(
        //     context: context,
        //     message: Config.emailPasswordInvalid,
        //   );
        // } else {
        //
        // }
      });
    } else {

      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      backgroundColor: HexColor(MyColors.colorLogin),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Centralized Registration for ITCGLOBAL",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                //styling
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.person_3_outlined,
                      color: Color(0xFF666666),
                      size: 15,
                    ),
                    fillColor: const Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                      color: const Color(0xFF666666),
                      fontFamily: Config.fontFamilyPoppinsMedium,
                    ),
                    hintText: "Name",
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    username = value;
                    if (value?.isEmpty == true ) {
                      return 'Enter a valid Name!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: refController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.person_3_outlined,
                      color: Color(0xFF666666),
                      size: 15,
                    ),
                    fillColor: const Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                      color: const Color(0xFF666666),
                      fontFamily: Config.fontFamilyPoppinsMedium,
                    ),
                    hintText: "Refarral Code (optional)",
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    //Validator
                  },

                ),
                SizedBox(
                  height:15,
                ),
                DropdownButtonFormField(
                    isExpanded: true,
                    items: dropdownItems,
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.location_pin,
                        color: Color(0xFF666666),
                        size: 15,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: Config.enterEmailPhoneNumber,
                    )),

                SizedBox(
                  height:15,
                ),
                //text input
                TextFormField(
                  controller: countryController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),



                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,


                    prefixIcon:Padding(
                      padding: const EdgeInsets.only(left: 15,top: 0,right: 0,bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                        mainAxisSize: MainAxisSize.min, // added line
                        children: [
                      Icon(
                        Icons.phone_android_outlined,
                        color: Color(0xFF666666),
                        size: 15,
                      ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              style: TextStyle(color: Colors.red),
                              '+'+selectedValue.split("Text")[0]??"",




                            ),
                          )
                        ],
                      ),
                    ),
                    fillColor: const Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                      color: const Color(0xFF666666),
                      fontFamily: Config.fontFamilyPoppinsMedium,
                    ),
                    hintText: Config.enterPhoneNumber,
                  ),
                  keyboardType: TextInputType.phone,
                  onFieldSubmitted: (value) {},
                  obscureText: false,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Enter a valid Mobile!';
                    }
                    return null;
                  },
                ),

                //box styling
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: Color(0xFF666666),
                      size: 15,
                    ),
                    fillColor: const Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                      color: const Color(0xFF666666),
                      fontFamily: Config.fontFamilyPoppinsMedium,
                    ),
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    email=value;
                    if (value?.isEmpty == true ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                ),
                //box styling

                //box styling
                SizedBox(
                  height: 15,
                ),
                //text input



                TextFormField(
                  obscureText: passenablen,
                  textAlignVertical: TextAlignVertical.center,
                  controller: newPassController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF666666),
                        size: 18,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: "New Password",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: (){ //add Icon button at end of TextField
                            setState(() { //refresh UI
                              if(passenablen){ //if passenable == true, make it false
                                passenablen = false;
                              }else{
                                passenablen = true; //if passenable == false, make it true
                              }
                            });
                          },
                          child: Icon(
                            passenablen
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                          ),
                        ),
                      )
                    // suffix: IconButton( splashRadius: 24.0, constraints: BoxConstraints(maxHeight: 10),iconSize: 20.0,onPressed: (){ //add Icon button at end of TextField
                    //   setState(() { //refresh UI
                    //     if(passenable){ //if passenable == true, make it false
                    //       passenable = false;
                    //     }else{
                    //       passenable = true; //if passenable == false, make it true
                    //     }
                    //   });
                    // }, icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password))
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    int? length = value?.length;
                    if (value?.isEmpty == true ) {
                      return 'Enter a valid password!';
                    }
                    if (length! < 8) {
                      return 'Password Should be minimum eight characters ';
                    }
                    if (value?.isEmpty == true||
                        !RegExp(r"^(?=.{8,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?\W).*$")
                            .hasMatch(value!)) {
                      return 'Enter at least one upper,lower and special characters';
                    }
                    npassword = value;
                    return null;
                  },
                ),




                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: passenablecn,
                  textAlignVertical: TextAlignVertical.center,
                  controller: cNewpassController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF666666),
                        size: 18,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: "Confirm New Password",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: (){ //add Icon button at end of TextField
                            setState(() { //refresh UI
                              if(passenablecn){ //if passenable == true, make it false
                                passenablecn = false;
                              }else{
                                passenablecn = true; //if passenable == false, make it true
                              }
                            });
                          },
                          child: Icon(
                            passenablecn
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                          ),
                        ),
                      )
                    // suffix: IconButton( splashRadius: 24.0, constraints: BoxConstraints(maxHeight: 10),iconSize: 20.0,onPressed: (){ //add Icon button at end of TextField
                    //   setState(() { //refresh UI
                    //     if(passenable){ //if passenable == true, make it false
                    //       passenable = false;
                    //     }else{
                    //       passenable = true; //if passenable == false, make it true
                    //     }
                    //   });
                    // }, icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password))
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    int? length = value?.length;
                    if (value?.isEmpty == true ) {
                      return 'Enter a valid password!';
                    }
                    if (length! < 6) {
                      return 'Password Should be minimum six characters ';
                    }
                    if(newPassController.text != cNewpassController.text){
                      return 'New and confirm new  passwords should be same';

                    }
                    cnpassword = value;
                    return null;
                  },
                ),

                Row(
                  children: [
                   Checkbox(


                        activeColor: Colors.lightBlue,
                        checkColor: Colors.white,
                        side:
                        BorderSide(width: 2, color: Colors.white),

                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                      ),


                     SizedBox(
                       width: MediaQuery.of(context).size.width-100,
                       child: Text(
                         style: TextStyle(color: Colors.white),
                        'Agree the terms and policy',
                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,

                    ),
                     )
                  ],
                ),

                ElevatedButton(
                  onPressed: () => _submit(),
                  child: const Text(Config.signup),
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.grey,
                      elevation: 3,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
                      minimumSize: const Size(double.infinity, 45)),
                )

                // RaisedButton(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 10.0,
                //     horizontal: 15.0,
                //   ),
                //   child: Text(
                //     "Submit",
                //     style: TextStyle(
                //       fontSize: 24.0,
                //     ),
                //   ),
                //   onPressed: () => _submit(),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Registration"),
  //     ),
  //     backgroundColor: HexColor(MyColors.colorLogin),
  //     body: SingleChildScrollView(
  //       child: Container(
  //
  //         margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
  //         padding: const EdgeInsets.all(10),
  //         child: Column(children: [
  //           // const SizedBox(height: 50),
  //           // buildLogo(),
  //           // const SizedBox(height: 50),
  //           //  buildHeading(),
  //           // const SizedBox(height: 10),
  //           // buildLoginText(),
  //           const SizedBox(height: 15),
  //           buildEmailEditText(),
  //           const SizedBox(height: 20),
  //           buildPasswordEditText(),
  //           const SizedBox(height: 15),
  //           buildEmailEditText(),
  //           const SizedBox(height: 15),
  //           buildEmailEditText(),
  //           const SizedBox(height: 15),
  //           buildEmailEditText(),
  //           const SizedBox(height: 15),
  //           buildEmailEditText(),
  //
  //           const SizedBox(height: 15),
  //           buildLoginButton(),
  //           const SizedBox(height: 30),
  //           notMember(),
  //           const SizedBox(height: 25),
  //           buildViewButton(),
  //           const SizedBox(
  //             height: 10,
  //           )
  //
  //
  //         ]),
  //       ),
  //     ),
  //   );
  // }

  buildLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/images/itc_logo1.png",
        height: 100,
      ),
    );
  }

  buildHeading() {
    return Container(
      alignment: Alignment.center,
      transformAlignment: Alignment.bottomLeft,
      child: Text(
        "Login",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: Config.fontFamilyPoppinsBold,
          fontSize: 20,
        ),
      ),
    );
  }

  buildLoginText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: InkWell(
        // onTap: () => navigateToSignUpLogin(),
        child: Text(
          Config.createNew,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: Config.fontFamilyPoppinsRegular,
          ),
        ),
      ),
    );
  }










}
