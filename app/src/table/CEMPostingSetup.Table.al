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
            TableRelation = IF (Type = CONST(Expense)) "CEM Expense Type"
            ELSE
            IF (Type = CONST(Mileage)) "CEM Vehicle"
            ELSE
            IF (Type = CONST("Per Diem")) "CEM Allowance";
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
            TableRelation = IF ("Country/Region Type" = CONST(Country)) "CEM Country/Region";

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

            trigger OnValidate()
            begin
                if xRec."Posting Account Type" <> "Posting Account Type" then
                    "Posting Account No." := '';

                if Type = Type::Mileage then
                    if not ("Posting Account Type" in
                      ["Posting Account Type"::" ", "Posting Account Type"::"G/L Account"])
                    then
                        Error(WrongPostingAccountTypeErr, Type);

                if "Posting Account Type" = "Posting Account Type"::Item then
                    if "External Posting Account Type" <> "External Posting Account Type"::" " then
                        Error(ItemAndExtErr, FieldCaption("External Posting Account Type"), FieldCaption("Posting Account Type"),
                          "Posting Account Type");

                if "Posting Account Type" <> xRec."Posting Account Type" then
                    CheckForExistingDocuments(false);
            end;
        }
        field(10; "Posting Account No."; Code[20])
        {
            Caption = 'Posting Account No.';
            TableRelation = IF ("Posting Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Posting Account Type" = CONST(Item)) Item;

            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
                Item: Record Item;
            begin
                if "Posting Account No." <> '' then
                    TestField("Posting Account Type");

                case "Posting Account Type" of
                    "Posting Account Type"::"G/L Account":
                        begin
                            GLAcc.Get("Posting Account No.");
                            GLAcc.CheckGLAcc;
                        end;

                    "Posting Account Type"::Item:
                        begin
                            TestField(Type, Type::Expense);
                            Item.Get("Posting Account No.");
                            Item.TestField(Blocked, false);
                            Item.TestField("Gen. Prod. Posting Group");
                        end;
                end;

                if "Posting Account No." <> xRec."Posting Account No." then
                    CheckForExistingDocuments(false);
            end;
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

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if "External Posting Account Type" in ["External Posting Account Type"::"Lessor Pay Type",
                  "External Posting Account Type"::"Dataloen Pay Type"]
                then begin
                    EMSetup.Get;
                    if EMSetup."Expense Posting" = EMSetup."Expense Posting"::"Preferable Purchase Invoice" then
                        Error(PurchasePostingNotAllowedErr, EMSetup.TableCaption, EMSetup.FieldCaption("Expense Posting"),
                          Format(EMSetup."Expense Posting"), TableCaption, Format("External Posting Account Type"));

                    if "Posting Account Type" = "Posting Account Type"::Item then
                        Error(ItemAndExtErr, FieldCaption("External Posting Account Type"), FieldCaption("Posting Account Type"),
                          "Posting Account Type");
                end;

                if "External Posting Account Type" <> xRec."External Posting Account Type" then begin
                    "External Posting Account No." := '';
                    CheckForExistingDocuments(true);
                end;
            end;
        }
        field(67; "External Posting Account No."; Code[20])
        {
            Caption = 'External Posting Account No.';
        }
        field(68; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                UpdateTaxGroupCodeOnOpenExp;
            end;
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

    var
        ItemAndExtErr: Label '%1 must be blank, when %2 is %3. %3 posting cannot be handled when using external integration systems.';
        MileageOnlyErr: Label '%2 in %1 must not be selected, when %3 is %4.';
        PostingSetupNotFoundErr: Label 'There is no %1 within the filter. Filters: %2: %3,%4: %5.';
        PurchasePostingNotAllowedErr: Label '%1 %2 cannot be %3, when %4 with %5 exists.';
        UpdateExpAccQst: Label 'There are %1 unposted expenses with account number ''%2'' for Expense Type %3.\Do you want to update all of them to account ''%4''?';
        UpdateMilAccQst: Label 'There are %1 unposted %2 with %3 ''%4'' for vehicle %5.\Do you want to update all of them to ''%6''?';
        UpdateTaxGroupDocQst: Label 'There are %1 unposted documents with %2 %3 for %4.\Do you want to update all of them to %2 ''%5''?';
        UpdateTaxGroupQst: Label 'There are %1 unposted expenses with %2 %3 for Expense Type %4.\Do you want to update all of them to %2 ''%5''?';
        WrongPostingAccountTypeErr: Label 'Account Type must be G/L Account or Blank when Type is %1.';
        ErrorTxt: Text[250];


    procedure FindPostingSetup(TableID: Integer; AccountNo: Code[20]; CountryRegion: Code[20]; Employee: Code[50]; Group: Code[20]; ShowErrorIfNotFound: Boolean): Boolean
    var
        ExpPostingSetup: Record "CEM Posting Setup";
        AccountType: Option Mileage,Expense,"Per Diem";
    begin
        case TableID of
            DATABASE::"CEM Expense":
                AccountType := AccountType::Expense;
            DATABASE::"CEM Mileage":
                AccountType := AccountType::Mileage;
            DATABASE::"CEM Per Diem":
                AccountType := AccountType::"Per Diem";
        end;

        // Same Employee and Employee Group, Country specific
        ExpPostingSetup.SetRange("No.", AccountNo);
        ExpPostingSetup.SetRange(Type, AccountType);
        ExpPostingSetup.SetRange("Employee No.", Employee);
        ExpPostingSetup.SetRange("Employee Group", Group);
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::Country);
        ExpPostingSetup.SetRange("Country/Region Code", CountryRegion);
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // Same Employee and Employee Group, all countries.
        ExpPostingSetup.SetRange("Employee No.", Employee);
        ExpPostingSetup.SetRange("Employee Group", Group);
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::"All Countries/Regions");
        ExpPostingSetup.SetRange("Country/Region Code");
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // Same Employee, Country specific
        ExpPostingSetup.SetRange("Employee No.", Employee);
        ExpPostingSetup.SetRange("Employee Group");
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::Country);
        ExpPostingSetup.SetRange("Country/Region Code", CountryRegion);
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // Same Employee, all countries
        ExpPostingSetup.SetRange("Employee No.", Employee);
        ExpPostingSetup.SetRange("Employee Group");
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::"All Countries/Regions");
        ExpPostingSetup.SetRange("Country/Region Code");
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // Same Employee Group, Country specific
        ExpPostingSetup.SetRange("Employee No.");
        ExpPostingSetup.SetRange("Employee Group", Group);
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::Country);
        ExpPostingSetup.SetRange("Country/Region Code", CountryRegion);
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // Same Employee Group, all countries
        ExpPostingSetup.SetRange("Employee No.");
        ExpPostingSetup.SetRange("Employee Group", Group);
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::"All Countries/Regions");
        ExpPostingSetup.SetRange("Country/Region Code");
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // A generic entry for all the users, country specific.
        ExpPostingSetup.SetRange("Employee No.", '');
        ExpPostingSetup.SetRange("Employee Group", '');
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::Country);
        ExpPostingSetup.SetRange("Country/Region Code", CountryRegion);
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        // A generic entry for all the users, all countries
        ExpPostingSetup.SetRange("Employee No.", '');
        ExpPostingSetup.SetRange("Employee Group", '');
        ExpPostingSetup.SetRange("Country/Region Type", "Country/Region Type"::"All Countries/Regions");
        ExpPostingSetup.SetRange("Country/Region Code");
        if ExpPostingSetup.FindFirst then begin
            Rec := ExpPostingSetup;
            exit(true);
        end;

        ErrorTxt := StrSubstNo(PostingSetupNotFoundErr, ExpPostingSetup.TableCaption,
          ExpPostingSetup.FieldCaption(Type), AccountType, ExpPostingSetup.FieldCaption("No."), AccountNo);

        if ShowErrorIfNotFound then
            Error(ErrorTxt);
    end;


    procedure LookupPostingAccount(var Text: Text[1024]): Boolean
    begin
    end;

    local procedure CheckForExistingDocuments(External: Boolean)
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
    begin
        case Type of
            Type::Expense:
                begin
                    Expense.SetRange("Expense Type", "No.");
                    Expense.SetRange("Exp. Account Manually Changed", false);
                    if External then
                        Expense.SetRange("External Posting Account Type", xRec."External Posting Account Type")
                    else
                        Expense.SetRange("Expense Account Type", xRec."Posting Account Type");

                    SetCommonFilterOnExpense(Expense);
                    if not Expense.IsEmpty then
                        if Confirm(UpdateExpAccQst, false, Format(Expense.Count), xRec."Posting Account No.", "No.", "Posting Account No.")
                        then begin
                            Expense.FindSet;
                            repeat
                                if External then begin
                                    Expense.Validate("External Posting Account Type", "External Posting Account Type");
                                    Expense.Validate("External Posting Account No.", "External Posting Account No.");
                                end else begin
                                    Expense.Validate("Expense Account Type", "Posting Account Type");
                                    Expense.Validate("Expense Account", "Posting Account No.");
                                end;
                                OnBeforeModifyExistingExpense(Rec, External, Expense);
                                Expense.Modify;
                            until Expense.Next = 0;
                        end;
                end;

            Type::Mileage:
                begin
                    Mileage.SetRange("Vehicle Code", "No.");
                    if External then begin
                        Mileage.SetRange("External Posting Account Type", xRec."External Posting Account Type");
                        Mileage.SetRange("External Posting Account No.", xRec."External Posting Account No.")
                    end else begin
                        Mileage.SetRange("Mileage Account Type", xRec."Posting Account Type");
                        Mileage.SetRange("Mileage Account", xRec."Posting Account No.");
                    end;

                    SetCommonFilterOnMileage(Mileage);
                    if not Mileage.IsEmpty then
                        if Confirm(UpdateMilAccQst, false, Format(Mileage.Count), Mileage.TableCaption,
                          Mileage.FieldCaption("Mileage Account"), xRec."Posting Account No.", "No.", "Posting Account No.")
                        then begin
                            Mileage.FindSet;
                            repeat
                                if External then begin
                                    Mileage.Validate("External Posting Account Type", "External Posting Account Type");
                                    Mileage.Validate("External Posting Account No.", "External Posting Account No.");
                                end else begin
                                    Mileage.Validate("Mileage Account Type", "Posting Account Type");
                                    Mileage.Validate("Mileage Account", "Posting Account No.");
                                end;
                                OnBeforeModifyExistingMileage(Rec, External, Mileage);
                                Mileage.Modify;
                            until Mileage.Next = 0;
                        end;
                end;
        end;
    end;

    local procedure SetCommonFilterOnExpense(var Expense: Record "CEM Expense")
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        Expense.SetRange(Posted, false);
        if "Employee No." <> '' then
            Expense.SetRange("Continia User ID", "Employee No.");
        if "Country/Region Code" <> '' then
            Expense.SetRange("Country/Region Code", "Country/Region Code");

        if not Expense.FindSet then
            exit;

        // MARK records belonging to the group
        repeat
            Expense.Mark(true);
            if "Employee Group" <> '' then begin
                ContiniaUserSetup.Get(Expense."Continia User ID");
                if ContiniaUserSetup."Expense User Group" <> "Employee Group" then
                    Expense.Mark(false);
            end;
        until Expense.Next = 0;

        Expense.MarkedOnly(true);
    end;

    local procedure SetCommonFilterOnMileage(var Mileage: Record "CEM Mileage")
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        Mileage.SetRange(Posted, false);
        if "Employee No." <> '' then
            Mileage.SetRange("Continia User ID", "Employee No.");

        if not Mileage.FindSet then
            exit;

        // MARK records belonging to the group
        repeat
            Mileage.Mark(true);
            if "Employee Group" <> '' then begin
                ContiniaUserSetup.Get(Mileage."Continia User ID");
                if ContiniaUserSetup."Expense User Group" <> "Employee Group" then
                    Mileage.Mark(false);
            end;
        until Mileage.Next = 0;

        Mileage.MarkedOnly(true);
    end;

    local procedure SetCommonFilterOnPerDiem(var PerDiem: Record "CEM Per Diem")
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        PerDiem.SetRange(Posted, false);
        if "Employee No." <> '' then
            PerDiem.SetRange("Continia User ID", "Employee No.");

        if not PerDiem.FindSet then
            exit;

        // MARK records belonging to the group
        repeat
            PerDiem.Mark(true);
            if "Employee Group" <> '' then begin
                ContiniaUserSetup.Get(PerDiem."Continia User ID");
                if ContiniaUserSetup."Expense User Group" <> "Employee Group" then
                    PerDiem.Mark(false);
            end;
        until PerDiem.Next = 0;

        PerDiem.MarkedOnly(true);
    end;

    local procedure UpdateTaxGroupCodeOnOpenExp()
    var
        Expense: Record "CEM Expense";
    begin
        // Method is obsolete and will be removed in the future.
        // It is replaced by UpdateTaxGroupCodeOnOpenDocs()

        Expense.SetRange("Tax Group Code", xRec."Tax Group Code");
        SetCommonFilterOnExpense(Expense);
        if not Expense.IsEmpty then
            if Confirm(
              UpdateTaxGroupQst, true, Format(Expense.Count), FieldCaption("Tax Group Code"), xRec."Tax Group Code", "No.", "Tax Group Code")
            then
                Expense.ModifyAll("Tax Group Code", "Tax Group Code");
    end;


    procedure GetErrorTxt(): Text[250]
    begin
        exit(ErrorTxt);
    end;


    procedure ShouldHandleCASalesTax(): Boolean
    var
        SalesTaxInterface: Codeunit "CEM Sales Tax Interface";
    begin
        // Control fields visibility inside EM
        // In this way the users cannot add the irrelevant fields in other localizations
        exit(SalesTaxInterface.ShouldHandleCASalesTax);
    end;

    local procedure UpdateTaxGroupCodeOnOpenDocs()
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case Type of
            Type::Expense:
                begin
                    Expense.SetRange("Tax Group Code", xRec."Tax Group Code");
                    SetCommonFilterOnExpense(Expense);
                    if not Expense.IsEmpty then
                        if Confirm(
                          UpdateTaxGroupDocQst, true, Format(Expense.Count),
                          FieldCaption("Tax Group Code"), xRec."Tax Group Code", "No.", "Tax Group Code")
                        then
                            Expense.ModifyAll("Tax Group Code", "Tax Group Code");
                end;

            Type::Mileage:
                begin
                    Mileage.SetRange("Tax Group Code", xRec."Tax Group Code");
                    SetCommonFilterOnMileage(Mileage);
                    if not Mileage.IsEmpty then
                        if Confirm(
                          UpdateTaxGroupDocQst, true, Format(Mileage.Count),
                          FieldCaption("Tax Group Code"), xRec."Tax Group Code", "No.", "Tax Group Code")
                        then
                            Mileage.ModifyAll("Tax Group Code", "Tax Group Code");

                end;

            Type::"Per Diem":
                begin
                    PerDiem.SetRange("Tax Group Code", xRec."Tax Group Code");
                    SetCommonFilterOnPerDiem(PerDiem);
                    if not PerDiem.IsEmpty then
                        if Confirm(
                          UpdateTaxGroupDocQst, true, Format(PerDiem.Count),
                          FieldCaption("Tax Group Code"), xRec."Tax Group Code", "No.", "Tax Group Code")
                        then
                            PerDiem.ModifyAll("Tax Group Code", "Tax Group Code");
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyExistingExpense(PostingSetup: Record "CEM Posting Setup"; External: Boolean; var Expense: Record "CEM Expense")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyExistingMileage(PostingSetup: Record "CEM Posting Setup"; External: Boolean; var Mileage: Record "CEM Mileage")
    begin
    end;
}

