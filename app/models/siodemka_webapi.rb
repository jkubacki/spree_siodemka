# Klasa WebAPI dla WebService7 firmy kurierskiej Siódemka.
# http://get.siodemka.com/WebService7.pdf
class SiodemkaWebapi

  attr_accessor :api_key, :client_number

  def initialize(wsdl = nil, api_key = nil, client_number = nil)
    wsdl = if wsdl.blank? then ENV['siodemka_wsdl'] else wsdl end
    @client = Savon.client(wsdl: wsdl)
    @api_key = if api_key.blank? then ENV['siodemka_api_key'] else api_key end
    @client_number = if client_number.blank? then ENV['siodemka_client_number'] else client_number end
  end

  # Metoda służy do wygenerowania w aplikacji WebMobile7 dokumentu wydania na podstawie
  # podanego zakresu listów przewozowych oraz jego pobrania. Zwraca dokument base64Binary PDF.
  def nowy_dokument_wydania(kurier, numery, separator = ';')
    call kurier: kurier, numery: numery, klucz: @api_key, separator: separator
  end

  # Metoda ta służy do pobrania numeru dokumentu wydania paczek.
  # Jako parametr przekazujemy numer przesyłki która załączona jest w pożądanym dokumencie.
  def pobierz_numer_dokumentu_list(numer_listu)
    call numer_listu: numer_listu, klucz: @api_key
  end


  # Metoda służy do pobrania wygenerowanego wcześniej w aplikacji WebMobile7 dokumentu wydania na podstawie
  # numeru dokumentu wydania. Informacją zwrotną dane binarne (base64Binary) z dokumentem pdf wydania.
  def pobierz_dokument_wydania(numer_dokumentu)
    call numer_dokumentu: numer_dokumentu, klucz: @api_key
  end

  # Metoda umożliwia śledzenie stanu (statusu) przesyłki z poziomu usług WebService7.
  def statusy_przesylki_v1(numer = '', nr_ext = '', czy_ostatni = 0)
    call numer_listu: numer, nr_ext: nr_ext, czy_ostatni: czy_ostatni, klucz: @api_key
  end

  # Metoda służy do pobrania z aplikacji WebMobile7 wydruku listu przewozowego w formacie A4,
  # na którym/ych ma zostać wykonana usługa transportowa  w postaci dokumentu base64Binary PDF.
  def wydruk_list_pdf(numer)
    call numer: numer, klucz: @api_key
  end

  # Metoda ta pozwala na pobranie etykiety adresowej (10 cm x 10 cm) w postaci dokumentu base64Binary PDF.
  def wydruk_etykieta_pdf(numery, separator = ';')
    call numery: numery, klucz: @api_key, separator: separator
  end

  # Metoda służy do wprowadzenia do aplikacji WebMobile7 informacji o liście przewozowym,
  # na którym ma zostać wykonana usługa transportowa.
  # Informacją zwrotną jest nadany numer przesyłki lub komunikat błędu.
  def list_nadanie(przesylka)
    call przesylka: przesylka, klucz: @api_key
  end

  # Metoda służy do wyszukiwania danych klienta po numerze klienta.
  # Zwracana jest lista obiektów o strukturze jak opisano w metodzie dodajNadawce (patrz typ danych Kontrahent w WSDL)
  def szukaj_klienta(number)
    call dane_klienta: { ulica: nil, email_kontakt: nil, imie: nil, numer: number, nazwisko: nil, nrDom: nil, nrLokal: nil, kod: nil, nrExt: nil, nazwa: nil, telKontakt: nil, nip: nil, czyFirma: nil, kodKraju: nil, miasto: nil, fax: nil, telefonKom: nil, czyNadawca: nil}, klucz: @api_key, tryb: 1
  end

  # Metoda służy do dodania do bazy danych klientów odbiorcy gotówkowego.
  # Dane wejściowe są przekazywane analogicznie jak opisano to powyżej w przypadku metody dodaj nadawce.
  # Zwracana jest analogiczna struktura z uzupełnionym numerem klienta.
  def dodaj_odbiorce(dane_klienta)
    call  dane_klienta: dane_klienta, klucz: @api_key
  end

  # Metoda służy do dodania do bazy danych klientów nadawcy gotówkowego.
  # Dane wejściowe są przekazywane w postaci struktury, która jest także wykorzystywana do dodawania odbiorcy,
  # edycji klienta i wyszukiwania klienta. Zwracana jest analogiczna struktura z uzupełnionym numerem klienta.
  # UWAGA !!! Użytkownik musi mieć nadane przez firmę Siódemka S. A. uprawnienia do używania tej metody.
  def dodaj_nadawce(dane_klienta)
    call dane_klienta: dane_klienta, klucz: @api_key
  end

  # Metoda służy do edycji danych klienta.
  # W celu edycji należy podać dane klienta jak w opisanych wyżej metodach dodajNadawce,
  # ale należy także uzupełnić pole numer klienta (patrz opis metody do wyszukiwania klienta).
  # Zwracana struktura zawiera nowe dane i ewentualnie NOWY numer klienta
  # UWAGA !!! Użytkownik musi mieć nadane przez firmę Siódemka S. A. uprawnienia do używania tej metody.
  def edytuj_klienta(dane_klienta)
    call dane_klienta: dane_klienta, klucz: @api_key
  end

  private
  def call(message)
    calling_method = caller[0][/`.*'/][1..-2]
    puts calling_method + " " + message.inspect
    @client.call(calling_method.to_sym, message: message).body["#{calling_method}_response_element".to_sym][:result]
  end
end