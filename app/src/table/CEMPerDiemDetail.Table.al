table 6086388 "CEM Per Diem Detail"
{
    Caption = 'Per Diem Detail';
    Permissions = TableData "CEM Per Diem" = rimd;

    fields
    {
        field(1; "Per Diem Entry No."; Integer)
        {
            Caption = 'Per Diem Entry No.';
            Editable = false;
            TableRelation = "CEM Per Diem";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(3; Date; Date)
        {
            Caption = 'Date';
            Editable = false;
        }
        field(4; "Accommodation Allowance"; Boolean)
        {
            Caption = 'Accommodation Allowance';
        }
        field(5; Breakfast; Boolean)
        {
            Caption = 'Breakfast';
        }
        field(6; Lunch; Boolean)
        {
            Caption = 'Lunch';
        }
        field(7; Dinner; Boolean)
        {
            Caption = 'Dinner';
        }
        field(8; "Transport Allowance"; Boolean)
        {
            Caption = 'Transport Allowance';
        }
        field(9; "Entertainment Allowance"; Boolean)
        {
            Caption = 'Entertainment Allowance';
        }
        field(10; "Drinks Allowance"; Boolean)
        {
            Caption = 'Drinks Allowance';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(12; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'Amount';
            Editable = false;
        }
        field(13; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(14; "Accommodation Allowance Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'Accommodation Allowance Amount';
            Editable = false;
        }
        field(15; "Meal Allowance Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'Meal Allowance Amount';
            Editable = false;
        }
        field(16; "Transport Allowance Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'Transport Allowance Amount';
            Editable = false;
        }
        field(17; "Entertainment Allowance Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'Entertainment Allowance Amount';
            Editable = false;
        }
        field(18; "Drinks Allowance Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Caption = 'Drinks Allowance Amount';
            Editable = false;
        }
        field(19; Modified; Boolean)
        {
            Caption = 'Modified';
            Editable = false;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(21; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(22; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
    }

    keys
    {
        key(Key1; "Per Diem Entry No.", "Entry No.", Date)
        {
            Clustered = true;
            SumIndexFields = "Accommodation Allowance Amount", "Meal Allowance Amount", "Transport Allowance Amount", "Drinks Allowance Amount", "Entertainment Allowance Amount", "Amount (LCY)", Amount;
        }
        key(Key2; "Per Diem Entry No.", Modified)
        {
        }
        key(Key3; "Per Diem Entry No.", Date)
        {
        }
    }
    procedure GetEntryNo(): Integer
    var
        PerDiemDetails: Record "CEM Per Diem Detail";
    begin
        Rec.TestField("Per Diem Entry No.");

        PerDiemDetails.SetRange("Per Diem Entry No.", "Per Diem Entry No.");
        if PerDiemDetails.FindLast() then
            exit(PerDiemDetails."Entry No." + 1)
        else
            exit(1);
    end;


    procedure SetSkipSendToUser(SkipSend: Boolean)
    begin
    end;


    procedure LoadAllAllowanceAmountsInArray(var AllowanceAmounts: array[5] of Decimal)
    begin
        Clear(AllowanceAmounts);
        AllowanceAmounts[1] := "Accommodation Allowance Amount";
        AllowanceAmounts[2] := "Meal Allowance Amount";
        AllowanceAmounts[3] := "Drinks Allowance Amount";
        AllowanceAmounts[4] := "Transport Allowance Amount";
        AllowanceAmounts[5] := "Entertainment Allowance Amount";
    end;

    local procedure IsFirstDay(): Boolean
    var
        PerDiemDetail: Record "CEM Per Diem Detail";
    begin
        PerDiemDetail.SetRange("Per Diem Entry No.", "Per Diem Entry No.");
        PerDiemDetail.SetFilter(Date, '<%1', Date);
        exit(PerDiemDetail.IsEmpty);
    end;


    procedure GetDestinationTxt() DestinationTxt: Text[1024]
    var
        PerDiemDestination: Record "CEM Per Diem Detail Dest.";
    begin
        PerDiemDestination.SetRange("Per Diem Entry No.", "Per Diem Entry No.");
        PerDiemDestination.SetRange("Per Diem Detail Entry No.", "Entry No.");
        if PerDiemDestination.IsEmpty then
            exit('');

        PerDiemDestination.FindSet();
        repeat
            PerDiemDestination.CalcFields("Destination Name");
            if DestinationTxt <> '' then
                DestinationTxt += ',';

            DestinationTxt += PerDiemDestination."Destination Name";
        until PerDiemDestination.Next() = 0;
    end;


    procedure DrillDownDestinations()
    begin
    end;


    procedure PerDiemHasDestination(): Boolean
    var
        PerDiemDestination: Record "CEM Per Diem Detail Dest.";
    begin
        PerDiemDestination.SetRange("Per Diem Detail Entry No.", "Entry No.");
        exit(not PerDiemDestination.IsEmpty);
    end;


    procedure GetLastDestination(): Code[10]
    begin
    end;

    procedure SendToExpenseUser(ShouldDelete: Boolean)
    begin
    end;

    procedure SetGlobalPerDiem(var PerDiem: Record "CEM Per Diem")
    begin
    end;
}