table 6086389 "CEM Tax Jurisdiction"
{
    Caption = 'Expense Management Tax Jurisdiction';
    DataCaptionFields = "Code", Description;
    LookupPageID = "Tax Jurisdictions";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Use for Sales Tax Difference"; Boolean)
        {
            Caption = 'Use for Sales Tax Difference';
            Description = 'Obsolete';
        }
        field(4; "Expense Type Reference"; Code[20])
        {
            Caption = 'Expense Type Code';
            TableRelation = "CEM Expense Type".Code;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure LoadStandardTaxJurisdictions()
    var
        EMTaxJurisdiction: Record "CEM Tax Jurisdiction";
        EMTaxJurisdictionTemp: Record "CEM Tax Jurisdiction" temporary;
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        // Reloads all the jurisdictions, saving previous EM setup
        EMTaxJurisdiction.SetFilter("Expense Type Reference", '<>%1', '');
        if EMTaxJurisdiction.FindSet then begin
            EMTaxJurisdictionTemp.DeleteAll;
            repeat
                EMTaxJurisdictionTemp.Copy(EMTaxJurisdiction);
                EMTaxJurisdictionTemp.Insert;
            until EMTaxJurisdiction.Next = 0;
        end;

        EMTaxJurisdiction.Reset;
        EMTaxJurisdiction.DeleteAll;

        if TaxJurisdiction.FindSet then
            repeat
                Clear(EMTaxJurisdiction);
                EMTaxJurisdiction.Code := TaxJurisdiction.Code;
                EMTaxJurisdiction.Description := TaxJurisdiction.Description;
                // Save previous EM Setup:
                if EMTaxJurisdictionTemp.Get(TaxJurisdiction.Code) then
                    EMTaxJurisdiction."Expense Type Reference" := EMTaxJurisdictionTemp."Expense Type Reference";
                EMTaxJurisdiction.Insert;
            until TaxJurisdiction.Next = 0;
    end;


    procedure MarkBasedOnTaxAreaCode(TaxAreaCode: Code[20])
    var
        TaxAreaLine: Record "Tax Area Line";
    begin
        TaxAreaLine.SetRange("Tax Area", TaxAreaCode);
        if TaxAreaLine.FindSet then
            repeat
                Rec.Get(TaxAreaLine."Tax Jurisdiction Code");
                Rec.Mark(true);
            until TaxAreaLine.Next = 0;
    end;
}

