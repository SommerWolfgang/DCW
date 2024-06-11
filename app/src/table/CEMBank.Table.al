table 6086314 "CEM Bank"
{
    Caption = 'Bank';
    DataCaptionFields = "Code", Name;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(20; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "Code", "Country/Region Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        BankAgreement: Record "CEM Bank Agreement";
    begin
        BankAgreement.SetRange("Bank Code", Code);
        BankAgreement.SetRange("Country/Region Code", "Country/Region Code");
        if not BankAgreement.IsEmpty then
            Error(Text001);
    end;

    var
        Text001: Label 'The bank cannot be deleted because there are one or more bank agreements for this bank.';


    procedure ShowCurrencyMap()
    var
        BankCurrencyMap: Record "CEM Bank Currency Map";
        BankCurrencyMapTemp: Record "CEM Bank Currency Map" temporary;
        BankTransInbox: Record "CEM Bank Transaction Inbox";
        Currency: Record Currency;
    begin
        BankCurrencyMap.SetRange("Bank Code", Code);
        BankCurrencyMap.SetRange("Bank Country/Region Code", "Country/Region Code");

        if BankCurrencyMap.FindFirst() then
            repeat
                BankCurrencyMapTemp := BankCurrencyMap;
                BankCurrencyMapTemp.Insert();
            until BankCurrencyMap.Next() = 0;

        BankTransInbox.SetCurrentKey("Bank Code", "Bank Country/Region", Status);
        BankTransInbox.SetRange("Bank Code", Code);
        BankTransInbox.SetRange("Bank Country/Region", "Country/Region Code");
        BankTransInbox.SetFilter(Status, '%1|%2', BankTransInbox.Status::Pending, BankTransInbox.Status::Error);
        if BankTransInbox.FindFirst() then
            repeat
                if not BankCurrencyMapTemp.Get(BankTransInbox."Bank Code",
                  BankTransInbox."Bank Country/Region", BankTransInbox."Currency Code")
                then begin
                    BankCurrencyMapTemp.Init();
                    BankCurrencyMapTemp."Bank Code" := BankTransInbox."Bank Code";
                    BankCurrencyMapTemp."Bank Country/Region Code" := BankTransInbox."Bank Country/Region";
                    BankCurrencyMapTemp."Currency Code (Bank)" := BankTransInbox."Currency Code";

                    if Currency.Get(BankTransInbox."Currency Code") then
                        BankCurrencyMapTemp."Currency Code (NAV)" := BankTransInbox."Currency Code";
                    BankCurrencyMapTemp.Insert();
                end;
            until BankTransInbox.Next() = 0;

        BankCurrencyMapTemp.SetRange("Bank Code", Code);
        BankCurrencyMapTemp.SetRange("Bank Country/Region Code", "Country/Region Code");
        PAGE.RunModal(0, BankCurrencyMapTemp);

        BankCurrencyMap.DeleteAll(true);

        if BankCurrencyMapTemp.FindFirst() then
            repeat
                if BankCurrencyMapTemp."Currency Code (Bank)" <> BankCurrencyMapTemp."Currency Code (NAV)" then begin
                    BankCurrencyMap := BankCurrencyMapTemp;
                    BankCurrencyMap.Insert();
                end;
            until BankCurrencyMapTemp.Next() = 0;
    end;


    procedure ShowCountryRegionMap()
    var
        BankCountryRegionMap: Record "CEM Bank Country/Region Map";
        BankCountryRegionMapTemp: Record "CEM Bank Country/Region Map" temporary;
        BankTransInbox: Record "CEM Bank Transaction Inbox";
        CountryRegion: Record "Country/Region";
    begin
        BankCountryRegionMap.SetRange("Bank Code", Code);
        BankCountryRegionMap.SetRange("Bank Country/Region Code", "Country/Region Code");
        if BankCountryRegionMap.FindFirst() then
            repeat
                BankCountryRegionMapTemp := BankCountryRegionMap;
                BankCountryRegionMapTemp.Insert();
            until BankCountryRegionMap.Next() = 0;

        BankTransInbox.SetCurrentKey("Bank Code", "Bank Country/Region", Status);
        BankTransInbox.SetRange("Bank Code", Code);
        BankTransInbox.SetRange("Bank Country/Region", "Country/Region Code");
        BankTransInbox.SetFilter(Status, '%1|%2', BankTransInbox.Status::Pending, BankTransInbox.Status::Error);
        if BankTransInbox.FindFirst() then
            repeat
                if not BankCountryRegionMapTemp.Get(BankTransInbox."Bank Code",
                   BankTransInbox."Bank Country/Region", BankTransInbox."Business Country/Region")
                then begin
                    BankCountryRegionMapTemp.Init();
                    BankCountryRegionMapTemp."Bank Code" := BankTransInbox."Bank Code";
                    BankCountryRegionMapTemp."Bank Country/Region Code" := BankTransInbox."Bank Country/Region";
                    BankCountryRegionMapTemp."Country/Region Code (Bank)" := BankTransInbox."Business Country/Region";

                    if StrLen(BankTransInbox."Business Country/Region") <= 10 then
                        if CountryRegion.Get(BankTransInbox."Business Country/Region") then
                            BankCountryRegionMapTemp."Country/Region Code (NAV)" := CountryRegion.Code;
                    BankCountryRegionMapTemp.Insert();
                end;
            until BankTransInbox.Next() = 0;

        BankCountryRegionMapTemp.SetRange("Bank Code", Code);
        BankCountryRegionMapTemp.SetRange("Bank Country/Region Code", "Country/Region Code");
        PAGE.RunModal(0, BankCountryRegionMapTemp);

        BankCountryRegionMap.DeleteAll(true);

        if BankCountryRegionMapTemp.FindFirst() then
            repeat
                if BankCountryRegionMapTemp."Country/Region Code (Bank)" <> BankCountryRegionMapTemp."Country/Region Code (NAV)" then begin
                    BankCountryRegionMap := BankCountryRegionMapTemp;
                    BankCountryRegionMap.Insert();
                end;
            until BankCountryRegionMapTemp.Next() = 0;
    end;
}

