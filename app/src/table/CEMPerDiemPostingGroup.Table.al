table 6086385 "CEM Per Diem Posting Group"
{
    Caption = 'Per Diem Posting Group';

    fields
    {
        field(1; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
            NotBlank = true;
            TableRelation = "CEM Per Diem Group";
        }
        field(2; "Destination Country/Region"; Code[10])
        {
            Caption = 'Destination Country/Region';
            TableRelation = "CEM Country/Region";
        }
        field(3; "Destination Name"; Text[50])
        {
            CalcFormula = Lookup("CEM Country/Region".Name WHERE(Code = FIELD("Destination Country/Region")));
            Caption = 'Destination Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Accommodation Allowance Code"; Code[20])
        {
            Caption = 'Accommodation Allowance Code';
            TableRelation = "CEM Allowance";
        }
        field(5; "Meal Allowance Code"; Code[20])
        {
            Caption = 'Meal Allowance Code';
            TableRelation = "CEM Allowance";
        }
        field(6; "Transport Allowance Code"; Code[20])
        {
            Caption = 'Transport Allowance Code';
            TableRelation = "CEM Allowance";

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if xRec."Transport Allowance Code" = "Transport Allowance Code" then
                    exit;

                if "Transport Allowance Code" <> '' then begin
                    EMSetup.Get;
                    if not EMSetup."Use Transport Allowance" then
                        Error(AllowanceCodeNotAllowedErr, EMSetup.TableCaption,
                          FieldCaption("Transport Allowance Code"), TableCaption, "Per Diem Group Code");
                end;
            end;
        }
        field(7; "Entertainment Allowance Code"; Code[20])
        {
            Caption = 'Entertainment Allowance Code';
            TableRelation = "CEM Allowance";

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if xRec."Entertainment Allowance Code" = "Entertainment Allowance Code" then
                    exit;

                if "Entertainment Allowance Code" <> '' then begin
                    EMSetup.Get;
                    if not EMSetup."Use Entertainment Allowance" then
                        Error(AllowanceCodeNotAllowedErr,
                          EMSetup.TableCaption, FieldCaption("Entertainment Allowance Code"), TableCaption, "Per Diem Group Code");
                end;
            end;
        }
        field(8; "Drinks Allowance Code"; Code[20])
        {
            Caption = 'Drinks Allowance Code';
            TableRelation = "CEM Allowance";

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if xRec."Drinks Allowance Code" = "Drinks Allowance Code" then
                    exit;

                if "Drinks Allowance Code" <> '' then begin
                    EMSetup.Get;
                    if (not EMSetup."Use Drinks Allowance") then
                        Error(AllowanceCodeNotAllowedErr,
                          EMSetup.TableCaption, FieldCaption("Drinks Allowance Code"), TableCaption, "Per Diem Group Code");
                end;
            end;
        }
        field(9; "Allowance Rates"; Integer)
        {
            CalcFormula = Count("CEM Per Diem Rate" WHERE("Per Diem Group Code" = FIELD("Per Diem Group Code"),
                                                           "Destination Country/Region" = FIELD("Destination Country/Region")));
            Caption = 'Allowance Rates';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Per Diem Group Code", "Destination Country/Region")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PerDiemRate: Record "CEM Per Diem Rate";
    begin
        PerDiemRate.SetRange("Per Diem Group Code", "Per Diem Group Code");
        PerDiemRate.SetRange("Destination Country/Region", "Destination Country/Region");
        PerDiemRate.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestField("Per Diem Group Code");
    end;

    trigger OnModify()
    begin
        TestField("Per Diem Group Code");
    end;

    trigger OnRename()
    begin
        TestField("Per Diem Group Code");
    end;

    var
        AllowanceCodeMissingErr: Label '%1 is missing on the %2 ''%3''.';
        AllowanceCodeNotAllowedErr: Label '%1 does not allow %2 to be used on %3 ''%4''.';
        LocalRateNotFoundCreateQst: Label 'Do you wish to setup a %1 for the %2?';
        RateNotFoundCreateQst: Label 'Do you wish to setup a %1 for the %2 in %3?';
        LastErrorTxt: Text[1024];


    procedure GetAllowancePostingSetup(ContUserID: Code[50]; AllowanceCode: Code[20]; var PostingSetup: Record "CEM Posting Setup"; ShowError: Boolean): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        ContiniaUserSetup.Get(ContUserID);
        exit(PostingSetup.FindPostingSetup(DATABASE::"CEM Per Diem", AllowanceCode, "Destination Country/Region",
          ContUserID, ContiniaUserSetup."Expense User Group", ShowError));
    end;


    procedure LoadAllowanceInArrayAndCheck(var AllowanceCodes: array[5] of Code[20]): Boolean
    begin
        if not CheckAllowanceSetup(false) then
            exit(false);

        Clear(AllowanceCodes);
        AllowanceCodes[1] := "Accommodation Allowance Code";
        AllowanceCodes[2] := "Meal Allowance Code";
        AllowanceCodes[3] := "Drinks Allowance Code";
        AllowanceCodes[4] := "Transport Allowance Code";
        AllowanceCodes[5] := "Entertainment Allowance Code";

        exit(true);
    end;


    procedure AllowanceRatesOnLookup(PerDiemPostingGroup: Record "CEM Per Diem Posting Group")
    var
        CountryRegion: Record "CEM Country/Region";
        PerDiemGroup: Record "CEM Per Diem Group";
        PerDiemRate: Record "CEM Per Diem Rate";
        Destination: Text[50];
        Question: Text[250];
    begin
        PerDiemGroup.Get(PerDiemPostingGroup."Per Diem Group Code");
        if PerDiemPostingGroup."Destination Country/Region" <> '' then
            if CountryRegion.Get(PerDiemPostingGroup."Destination Country/Region") then
                Destination := CountryRegion.Name;

        if Destination = '' then
            Question := LocalRateNotFoundCreateQst
        else
            Question := RateNotFoundCreateQst;

        PerDiemRate.SetRange("Per Diem Group Code", PerDiemPostingGroup."Per Diem Group Code");
        PerDiemRate.SetRange("Destination Country/Region", PerDiemPostingGroup."Destination Country/Region");
        PerDiemRate.SetRange("Start Date", 0D, Today);
        if PerDiemRate.FindLast then begin
            PerDiemRate.SetRange("Start Date");
            PAGE.Run(PAGE::"CEM Per Diem Rate Card", PerDiemRate, PerDiemRate."Start Date")
        end else
            if Confirm(Question, true, PerDiemRate.TableCaption,
                PerDiemGroup.Description, CountryRegion.Name)
            then begin
                PerDiemRate.Init;
                PerDiemRate."Per Diem Group Code" := PerDiemPostingGroup."Per Diem Group Code";
                PerDiemRate."Destination Country/Region" := PerDiemPostingGroup."Destination Country/Region";
                Evaluate(PerDiemRate."Start Date", Format('0101' + Format(Date2DMY(Today, 3))));
                PerDiemRate.Insert(true);
                PAGE.Run(PAGE::"CEM Per Diem Rate Card", PerDiemRate, PerDiemRate."Start Date");
            end else begin
                PerDiemRate.SetRange("Start Date");
                if PerDiemRate.FindLast then;
                PAGE.Run(PAGE::"CEM Per Diem Rate Card", PerDiemRate, PerDiemRate."Start Date")
            end;
    end;


    procedure GetAllowanceCodeFieldCaption(FieldNo: Integer): Text[250]
    begin
        case FieldNo of
            1:
                exit(FieldCaption("Accommodation Allowance Code"));
            2:
                exit(FieldCaption("Meal Allowance Code"));
            3:
                exit(FieldCaption("Drinks Allowance Code"));
            4:
                exit(FieldCaption("Transport Allowance Code"));
            5:
                exit(FieldCaption("Entertainment Allowance Code"));
        end;
    end;


    procedure CheckAllowanceSetup(ShowError: Boolean): Boolean
    var
        EMSetup: Record "CEM Expense Management Setup";
    begin
        EMSetup.Get;
        Clear(LastErrorTxt);

        CheckAllowanceReqAndSaveErr(true, "Accommodation Allowance Code", FieldCaption("Accommodation Allowance Code"));
        CheckAllowanceReqAndSaveErr(true, "Meal Allowance Code", FieldCaption("Meal Allowance Code"));
        CheckAllowanceReqAndSaveErr(EMSetup."Use Drinks Allowance", "Drinks Allowance Code", FieldCaption("Drinks Allowance Code"));
        CheckAllowanceReqAndSaveErr(
          EMSetup."Use Transport Allowance", "Transport Allowance Code", FieldCaption("Transport Allowance Code"));
        CheckAllowanceReqAndSaveErr(
          EMSetup."Use Entertainment Allowance", "Entertainment Allowance Code", FieldCaption("Entertainment Allowance Code"));

        exit(LastErrorTxt = '');
    end;


    procedure GetLastErrorText(): Text[1024]
    begin
        exit(LastErrorTxt);
    end;

    local procedure CheckAllowanceReqAndSaveErr(IsRequired: Boolean; AllowanceCode: Code[20]; FldCaption: Text[250])
    var
        EMSetup: Record "CEM Expense Management Setup";
    begin
        if IsRequired and (AllowanceCode = '') then
            LastErrorTxt := StrSubstNo(AllowanceCodeMissingErr, FldCaption, TableCaption, "Per Diem Group Code");

        if (not IsRequired) and (AllowanceCode <> '') then
            LastErrorTxt := StrSubstNo(AllowanceCodeNotAllowedErr, EMSetup.TableCaption, FldCaption, TableCaption, "Per Diem Group Code");
    end;


    procedure DisableTransportAllowance()
    var
        PerDiemPostingGroup: Record "CEM Per Diem Posting Group";
    begin
        PerDiemPostingGroup.ModifyAll("Transport Allowance Code", '');
    end;


    procedure DisableEntertainmentAllowance()
    var
        PerDiemPostingGroup: Record "CEM Per Diem Posting Group";
    begin
        PerDiemPostingGroup.ModifyAll("Entertainment Allowance Code", '');
    end;


    procedure DisableDrinksAllowance()
    var
        PerDiemPostingGroup: Record "CEM Per Diem Posting Group";
    begin
        PerDiemPostingGroup.ModifyAll("Drinks Allowance Code", '');
    end;


    procedure DisableAllowanceDep(Transport: Boolean; Entertainment: Boolean; Drinks: Boolean)
    begin
    end;
}

