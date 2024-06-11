table 6086309 "CEM Posting Setup"
{
    Caption = 'Posting Setup';
    DataCaptionFields = "No.";
    Permissions = TableData "CEM Posting Setup" = rimd;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Mileage,Expense,"Per Diem";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'Type Code';
            TableRelation = if (Type = const(Expense)) "CEM Expense Type"
            else
            if (Type = const(Mileage)) "CEM Vehicle"
            else
            if (Type = const("Per Diem")) "CEM Allowance";
        }
        field(3; "Country/Region Type"; Option)
        {
            Caption = 'Country/Region Type';
            OptionCaption = 'All Countries/Regions,Country';
            OptionMembers = "All Countries/Regions",Country;

            trigger OnValidate()
            begin
                if xRec."Country/Region Type" <> "Country/Region Type" then
                    "Country/Region Code" := '';
            end;
        }
        field(4; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = if ("Country/Region Type" = const(Country)) "CEM Country/Region";

            trigger OnValidate()
            begin
                TestField("Country/Region Type", "Country/Region Type"::Country);
                TestField("Country/Region Code");
            end;
        }
        field(5; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
            TableRelation = "CDC Continia User Setup";
        }
        field(8; "Employee Group"; Code[20])
        {
            Caption = 'Employee Group';
            TableRelation = "CEM Expense User Group";
        }
        field(9; "Posting Account Type"; Option)
        {
            Caption = 'Posting Account Type';
            OptionCaption = ' ,G/L Account,,,Item';
            OptionMembers = " ","G/L Account",,,Item;
        }
        field(10; "Posting Account No."; Code[20])
        {
            Caption = 'Posting Account No.';
        }
        field(45; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(46; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(58; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(59; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65; "External Posting Account Type"; Option)
        {
            Caption = 'External Posting Account Type';
            OptionCaption = ' ,Lessor Pay Type,Dataloen Pay Type';
            OptionMembers = " ","Lessor Pay Type","Dataloen Pay Type";
        }
        field(67; "External Posting Account No."; Code[20])
        {
            Caption = 'External Posting Account No.';
        }
        field(68; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Country/Region Type", "Country/Region Code", "Employee Group", "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Country/Region Type" = "Country/Region Type"::Country then
            TestField("Country/Region Code");
    end;

    trigger OnModify()
    begin
        if "Country/Region Type" = "Country/Region Type"::Country then
            TestField("Country/Region Code");
    end;

    procedure FindPostingSetup(TableID: Integer; AccountNo: Code[20]; CountryRegion: Code[20]; Employee: Code[50]; Group: Code[20]; ShowErrorIfNotFound: Boolean): Boolean
    begin
    end;

    procedure LookupPostingAccount(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure GetErrorTxt(): Text[250]
    begin
    end;

    procedure ShouldHandleCASalesTax(): Boolean
    begin
    end;
}