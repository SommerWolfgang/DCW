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

            trigger OnValidate()
            begin
                if "Accommodation Allowance" and IsFirstDay then
                    Error(AccommodationNotAllowed);
            end;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Destinations: Record "CEM Per Diem Detail Dest.";
    begin
        Destinations.SetRange("Per Diem Entry No.", Rec."Per Diem Entry No.");
        Destinations.SetRange("Per Diem Detail Entry No.", Rec."Entry No.");
        Destinations.DeleteAll;

        if not SkipSendToExpUser then
            SendToExpenseUser(true);
    end;

    trigger OnInsert()
    begin
        "Entry No." := GetEntryNo;
    end;

    trigger OnModify()
    begin
        Modified := true;
        PerDiemCalcEngine.FindRateAndUpdateAmtOnDetail(Rec);

        if not SkipSendToExpUser then
            SendToExpenseUser(false);
    end;

    var
        PerDiemGlobal: Record "CEM Per Diem";
        PerDiemCalcEngine: Codeunit "CEM Per Diem Calc. Engine";
        GotPerDiem: Boolean;
        PerDiemLoaded: Boolean;
        SkipSendToExpUser: Boolean;
        AccommodationNotAllowed: Label 'Accommodation cannot be selected on the first day';


    procedure GetEntryNo(): Integer
    var
        PerDiemDetails: Record "CEM Per Diem Detail";
    begin
        Rec.TestField("Per Diem Entry No.");

        PerDiemDetails.SetRange("Per Diem Entry No.", "Per Diem Entry No.");
        if PerDiemDetails.FindLast then
            exit(PerDiemDetails."Entry No." + 1)
        else
            exit(1);
    end;


    procedure SetSkipSendToUser(SkipSend: Boolean)
    begin
        SkipSendToExpUser := SkipSend;
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

        PerDiemDestination.FindSet;
        repeat
            PerDiemDestination.CalcFields("Destination Name");
            if DestinationTxt <> '' then
                DestinationTxt += ',';

            DestinationTxt += PerDiemDestination."Destination Name";
        until PerDiemDestination.Next = 0;
    end;


    procedure DrillDownDestinations()
    var
        PerDiemDestination: Record "CEM Per Diem Detail Dest.";
        PerDiemDestinationsPage: Page "CEM Per Diem Destinations";
    begin
        PerDiemDestination.SetRange("Per Diem Entry No.", "Per Diem Entry No.");
        PerDiemDestination.SetRange("Per Diem Detail Entry No.", Rec."Entry No.");

        PerDiemDestinationsPage.SetTableView(PerDiemDestination);
        PerDiemDestinationsPage.Editable(true);
        PerDiemDestinationsPage.RunModal;
    end;


    procedure PerDiemHasDestination(): Boolean
    var
        PerDiemDestination: Record "CEM Per Diem Detail Dest.";
    begin
        PerDiemDestination.SetRange("Per Diem Detail Entry No.", "Entry No.");
        exit(not PerDiemDestination.IsEmpty);
    end;


    procedure GetLastDestination(): Code[10]
    var
        PerDiemDetail: Record "CEM Per Diem Detail";
        PerDiemDetailDest: Record "CEM Per Diem Detail Dest.";
        DestCountry: Code[20];
    begin
        // Last destination must be returned, with the following exception:
        // When the user is returning home from a specific country, he gets the rate of that specific country instead of the home rate

        if not GetPerDiem(Rec."Per Diem Entry No.") then
            exit;

        PerDiemDetail.Ascending(false);
        PerDiemDetail.SetRange("Per Diem Entry No.", Rec."Per Diem Entry No.");
        PerDiemDetail.SetFilter("Entry No.", '<=%1', "Entry No.");
        if PerDiemDetail.Find('-') then
            repeat
                Clear(DestCountry);
                if GetLastDestinationCountry(PerDiemDetail, DestCountry) then
                    if (DestCountry = PerDiemGlobal."Departure Country/Region") then begin
                        // If the user is returning in the home coutry, he needs to stay more than one day in order to get the rate.
                        // Otherwise it is considered just a return for a trip abroad
                        if IsNextDayDestinationInHomeCountry(PerDiemDetail) then
                            exit(PerDiemGlobal."Departure Country/Region");
                    end else
                        exit(DestCountry);

            until PerDiemDetail.Next = 0;

        // Destination should only be used if no other Detail destination is specified. It should never overwrite the detail destinations.
        if PerDiemGlobal."Destination Country/Region" <> '' then
            exit(PerDiemGlobal."Destination Country/Region");

        // No Destination was found on the Per Diem Details, then we take the Departure destination.
        exit(PerDiemGlobal."Departure Country/Region");
    end;

    local procedure GetLastDestinationCountry(PerDiemDetail: Record "CEM Per Diem Detail"; var DestCountry: Code[10]): Boolean
    var
        PerDiemDetailDestination: Record "CEM Per Diem Detail Dest.";
    begin
        PerDiemDetailDestination.SetCurrentKey("Arrival Time");
        PerDiemDetailDestination.SetRange("Per Diem Entry No.", PerDiemDetail."Per Diem Entry No.");
        PerDiemDetailDestination.SetRange("Per Diem Detail Entry No.", PerDiemDetail."Entry No.");
        PerDiemDetailDestination.SetFilter("Destination Country/Region", '<>%1', '');
        if PerDiemDetailDestination.FindLast then begin
            DestCountry := PerDiemDetailDestination."Destination Country/Region";
            exit(true);
        end;
    end;

    local procedure IsNextDayDestinationInHomeCountry(PerDiemDetail: Record "CEM Per Diem Detail"): Boolean
    var
        PerDiemDetail2: Record "CEM Per Diem Detail";
        PerDiemDetailDestination: Record "CEM Per Diem Detail Dest.";
    begin
        // Find the next Per Diem Detail
        PerDiemDetail2.SetRange("Per Diem Entry No.", PerDiemDetail."Per Diem Entry No.");
        PerDiemDetail2.SetFilter("Entry No.", '>%1', PerDiemDetail."Entry No.");
        if not PerDiemDetail2.FindFirst then
            exit(false);

        PerDiemDetailDestination.SetCurrentKey("Arrival Time");
        PerDiemDetailDestination.SetRange("Per Diem Entry No.", PerDiemDetail2."Per Diem Entry No.");
        PerDiemDetailDestination.SetRange("Per Diem Detail Entry No.", PerDiemDetail2."Entry No.");
        PerDiemDetailDestination.SetFilter("Destination Country/Region", '<>%1', '');
        if not PerDiemDetailDestination.FindLast then
            exit(true); // No destination was specified for this day. Last known address wins.

        exit(PerDiemDetailDestination."Destination Country/Region" = PerDiemGlobal."Departure Country/Region");
    end;


    procedure SendToExpenseUser(ShouldDelete: Boolean)
    var
        PerDiem: Record "CEM Per Diem";
        PerDiemDetail: Record "CEM Per Diem Detail";
        PerDiemDetailTemp: Record "CEM Per Diem Detail" temporary;
        SendToExpUser: Codeunit "CEM Per Diem - Send to User";
    begin
        PerDiem.Get("Per Diem Entry No.");

        if not (PerDiem.Status = PerDiem.Status::"Pending Expense User") then
            exit;

        PerDiemDetailTemp.DeleteAll;

        // Load commited and un-commited data from the page.
        PerDiemDetail.SetRange("Per Diem Entry No.", PerDiem."Entry No.");
        if PerDiemDetail.FindSet then
            repeat
                PerDiemDetailTemp.TransferFields(PerDiemDetail);
                PerDiemDetailTemp.Insert;
            until PerDiemDetail.Next = 0;

        if ShouldDelete then begin
            if PerDiemDetailTemp.Get(Rec."Per Diem Entry No.", Rec."Entry No.", Rec.Date) then
                PerDiemDetailTemp.Delete;
        end else
            if PerDiemDetailTemp.Get(Rec."Per Diem Entry No.", Rec."Entry No.", Rec.Date) then begin
                PerDiemDetailTemp := Rec;
                PerDiemDetailTemp.Modify;
            end else begin
                PerDiemDetailTemp := Rec;
                PerDiemDetailTemp."Entry No." += 1;
                PerDiemDetailTemp.Insert;
            end;

        SendToExpUser.SetPerDiemDetails(PerDiemDetailTemp);
        SendToExpUser.Update(PerDiem);
    end;


    procedure SetGlobalPerDiem(var PerDiem: Record "CEM Per Diem")
    begin
        // When Per Diem is un-commited we shouldn't read it from the database.

        PerDiemGlobal := PerDiem;
        PerDiemLoaded := true;
    end;

    local procedure GetPerDiem(PerDiemEntryNo: Integer): Boolean
    begin
        if PerDiemLoaded and (PerDiemEntryNo = PerDiemGlobal."Entry No.") then
            exit(true);

        exit(PerDiemGlobal.Get(PerDiemEntryNo));
    end;
}

