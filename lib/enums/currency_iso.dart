part of my_fatoorah;

enum Country {
  Kuwait,
  SaudiArabia,
  Bahrain,
  UAE,
  Qatar,
  Oman,
  Jordan,
}

Map<Country, String> _currencies = {
  Country.Kuwait: "KWD",
  Country.SaudiArabia: "SAR",
  Country.Bahrain: "BHD",
  Country.UAE: "AED",
  Country.Qatar: "QAR",
  Country.Oman: "OMR",
  Country.Jordan: "JOD",
};

Map<Country, String> mobiles = {
  Country.Kuwait: "+965",
  Country.SaudiArabia: "+966",
  Country.Bahrain: "+973",
  Country.UAE: "+971",
  Country.Qatar: "+974",
  Country.Oman: "+968",
  Country.Jordan: "+962",
};
