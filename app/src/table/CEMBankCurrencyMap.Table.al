table 6086310 "CEM Bank Currency Map"
{
    Caption = 'Bank Currency Map';
    DataCaptionFields = "Bank Code", "Bank Country/Region Code";

    fields
    {
        field(1; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            NotBlank = true;
            TableRelation = "CEM Bank";
        }
        field(2; "Bank Country/Region Code"; Code[10])
        {
            Caption = 'Bank Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(3; "Currency Code (Bank)"; Code[10])
        {
            Caption = 'Currency Code (Bank)';
            NotBlank = true;
        }
        field(10; "Currency Code (NAV)"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                "Local Currency" := "Currency Code (NAV)" = '';
            end;
        }
        field(11; "Local Currency"; Boolean)
        {
            Caption = 'Local Currency';

            trigger OnValidate()
            begin
                if "Local Currency" then
                    TestField("Currency Code (NAV)", '');
            end;
        }
    }

    keys
    {
        key(Key1; "Bank Code", "Bank Country/Region Code", "Currency Code (Bank)")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        MultipleCurrenciesQst: Label 'Multiple currencies are mapped to the local currency:\%1\Are you sure you want to continue?';


    procedure GetNAVCurrencyCode(BankCode: Code[10]; BankCountryRegion: Code[10]; CurrencyCode: Code[10]): Code[10]
    var
        BankCurrMap: Record "CEM Bank Currency Map";
    begin
        BankCurrMap.Get(BankCode, BankCountryRegion, CurrencyCode);
        if not BankCurrMap."Local Currency" then
            BankCurrMap.TestField("Currency Code (NAV)");

        exit(BankCurrMap."Currency Code (NAV)");
    end;


    procedure CheckConfirmMultipleCurrToLCY(var BankCurrencyMapTemp: Record "CEM Bank Currency Map" temporary)
    var
        CurrenciesString: Text[250];
    begin
        if not "Local Currency" then
            exit;

        CurrenciesString := GetStringOfOtherLCYCodes(BankCurrencyMapTemp);
        if CurrenciesString <> '' then begin
            CurrenciesString := CurrenciesString + ',' + "Currency Code (Bank)";
            if not Confirm(MultipleCurrenciesQst, true, CurrenciesString) then
                Error('');
        end;
    end;


    procedure GetStringOfOtherLCYCodes(var BankCurrencyMapTemp: Record "CEM Bank Currency Map" temporary) CurrTxt: Text[250]
    var
        xBankCurrencyMapTemp: Record "CEM Bank Currency Map";
    begin
        if BankCurrencyMapTemp.IsEmpty then
            exit;

        xBankCurrencyMapTemp := BankCurrencyMapTemp;

        BankCurrencyMapTemp.SetRange("Local Currency", true);
        if not BankCurrencyMapTemp.IsEmpty then begin
            BankCurrencyMapTemp.FindSet;
            repeat
                if CurrTxt = '' then
                    CurrTxt := BankCurrencyMapTemp."Currency Code (Bank)"
                else
                    CurrTxt := CurrTxt + ',' + BankCurrencyMapTemp."Currency Code (Bank)";
            until BankCurrencyMapTemp.Next = 0;
        end;
        BankCurrencyMapTemp.SetRange("Local Currency");

        BankCurrencyMapTemp := xBankCurrencyMapTemp;
    end;


    procedure GetLocalCurrCaptionClass(): Text[250]
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        exit(FieldCaption("Local Currency") + StrSubstNo('(%1)', GLSetup."LCY Code"));
    end;
}

