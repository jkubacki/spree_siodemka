class SiodemkaHelper
  def odbiorca_sort!(odbiorca)
    {
        numer: odbiorca[:numer],
        nr_ext: odbiorca[:nr_ext],
        czy_firma: odbiorca[:czy_firma],
        nazwa: odbiorca[:nazwa],
        # nip: odbiorca[:nip],
        nip: '',
        # nazwisko: odbiorca[:nazwisko],
        nazwisko: 'Kubacki',
        # imie: odbiorca[:imie],
        imie: 'Maciej',
        # kodKraju: odbiorca[:kodKraju],
        kod_kraju: 'PL',
        kod: odbiorca[:kod],
        miasto: odbiorca[:miasto],
        ulica: odbiorca[:ulica],
        nr_dom: odbiorca[:nr_dom],
        nr_lokal: odbiorca[:nr_lokal],
        tel_kontakt: odbiorca[:tel_kontakt],
        email_kontakt: odbiorca[:email_kontakt]
    }
  end

  def przesylka(odbiorca, number_ext = '')
    {
        nr_przesylki: '',
        nr_ext: number_ext,
        mpk: @client_number,
        rodzaj_przesylki: 'K',
        placi: 1,
        forma_platnosci: 'G',
        nadawca: {
            numer: @client_number,
            nazwisko: 'Kubacki',
            imie: 'Jakub',
            tel_kontakt: '500525246',
            email_kontakt: 'kooboolc@gmail.com',
        },
        odbiorca: odbiorca,
        platnik: {
            numer: @client_number,
            tel_kontakt: '500525246'
        },
        uslugi: {
            nr_bezpiecznej_koperty: '',
            zkld: '',
            zd: '',
            ubezpieczenie: {
                kwota_ubezpieczenia: '',
                opis_zawartosci: ''
            },
            pobranie: {
                kwota_pobrania: '',
                forma_pobrania: '',
                nrKonta: '',
            },
            awizacja_telefoniczna: 0,
            potw_nad_email: 1,
            potw_dost_email: 0,
            potw_dost_SMS: 0,
            skladowanie: 0,
            nad_odb_PKP: 0,
            odb_nadgodziny: 0,
            odb_wlas: 0,
            pal_next_day: 0,
            osoba_fiz: 0,
            market: 0,
            zastrz_dor_na_godz: 0,
            zastrz_dor_na_dzien: 'B'
        },
        paczki: {
            paczka: {
                nrpp: '',
                typ: 'PC',
                waga: 20,
                gab1: 0,
                gab2: 0,
                gab3: 0,
                ksztalt: 0,
                waga_gabaryt: ''
            },
        },
        potwierdzenie_nadania: {
            data_nadania: '2014-07-16 15:00',
            numer_kuriera: 194,
            podpis_nadawcy: 'Kubacki',
        },
        uwagi: 'UWAGI',
    }
  end

  # Creates user data from spree user
  def user_data(user, number = nil, sender = 0)
    address = user.ship_address
    number = if address.siodemka_number.blank? then @client_number else address.siodemka_number end
    {
        ulica: address.address1,
        email_kontakt: user.email,
        imie: address.firstname,
        numer: number,
        nazwisko: address.lastname,
        nrDom: address.address2,
        nrLokal: address.address2,
        kod: address.zipcode,
        nrExt: user.id,
        nazwa: if address.company.blank? then "#{address.firstname} #{address.lastname}" else address.company end,
        telKontakt: address.phone,
        nip: false,
        czyFirma: if address.company.blank? then 0 else 1 end,
        kodKraju: address.country.iso,
        miasto: address.city,
        fax: false,
        telefonKom: false,
        czyNadawca: sender
    }
  end
end