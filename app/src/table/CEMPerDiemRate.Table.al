table 6086381 "CEM Per Diem Rate"
{
    Caption = 'Per Diem Rate';

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
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
            NotBlank = true;
        }
        field(10; "Daily Accomondation Allowance"; Decimal)
        {
            Caption = 'Daily Accommodation Allowance';
        }
        field(11; "Daily Meal Allowance"; Decimal)
        {
            Caption = 'Daily Meal Allowance';
        }
        field(12; "Meal Value Method"; Option)
        {
            Caption = 'Meal Value Method';
            OptionCaption = 'Percentage,Amount';
            OptionMembers = Percentage,Amount;
        }
        field(13; "Breakfast Value"; Decimal)
        {
            Caption = 'Breakfast';
        }
        field(14; "Lunch Value"; Decimal)
        {
            Caption = 'Lunch';
        }
        field(15; "Dinner Value"; Decimal)
        {
            Caption = 'Dinner';
        }
        field(16; "Daily Drinks Allowance"; Decimal)
        {
            Caption = 'Daily Drinks Allowance';
        }
        field(17; "Daily Transport Allowance"; Decimal)
        {
            Caption = 'Daily Transport Allowance';
        }
        field(18; "Daily Entertainment Allowance"; Decimal)
        {
            Caption = 'Daily Entertainment Allowance';
        }
        field(19; "Minimum Stay (hours)"; Integer)
        {
            Caption = 'Minimum Stay (hours)';
        }
        field(21; "First/Last Day Calc. Method"; Option)
        {
            Caption = 'First/Last day calculation method';
            OptionCaption = 'Hourly Ratio,Sub rates,First/Last day fixed rate';
            OptionMembers = "Hourly Ratio","Sub rates","First/Last day fixed rate";
        }
        field(22; "First/Last Day Minimum Stay"; Integer)
        {
            Caption = 'First/Last Day Minimum Stay';
        }
        field(23; "Half Day Starting Time"; Time)
        {
            Caption = 'Half Day Starting Time';
        }
        field(24; "Half Day Latest Time"; Time)
        {
            Caption = 'Half Day Latest Time';
        }
        field(25; "First/Last Day Meal Allowance"; Decimal)
        {
            Caption = 'First/Last Day Meal Allowance';
        }
        field(26; "Rounding Type"; Option)
        {
            Caption = 'Rounding Type';
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = Nearest,Up,Down;
        }
        field(27; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(28; Description; Text[150])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Per Diem Group Code", "Destination Country/Region", "Start Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PerDiemRateDetails: Record "CEM Per Diem Rate Details";
    begin
        PerDiemRateDetails.SetRange("Per Diem Group Code", "Per Diem Group Code");
        PerDiemRateDetails.SetRange("Destination Country/Region", "Destination Country/Region");
        PerDiemRateDetails.SetRange("Start Date", "Start Date");
        PerDiemRateDetails.DeleteAll();
    end;

    trigger OnInsert()
    begin
        SuggestDescription();
        TestField("Per Diem Group Code");
        TestField("Start Date");
    end;

    trigger OnModify()
    begin
        TestField("Per Diem Group Code");
        TestField("Start Date");
        SuggestDescription();
    end;

    trigger OnRename()
    begin
        TestField("Per Diem Group Code");
        TestField("Start Date");
    end;

    var
        RatesCouldBeExpiringSoon: Label 'Per diem rates should be updated every year.\Do you want to review them now?';
        RatesOlderThanOneYear: Label 'The Per Diem rates are more than a year old.\Please consider updating them.';


    procedure SuggestDescription()
    var
        CountryRegion: Record "CEM Country/Region";
        PerDiemGroup: Record "CEM Per Diem Group";
    begin
        if Description <> '' then
            exit;

        if ("Per Diem Group Code" = '') or ("Start Date" = 0D) then
            exit;

        if PerDiemGroup.Get("Per Diem Group Code") then
            AppendTextToDescription(PerDiemGroup.Description);

        if CountryRegion.Get("Destination Country/Region") then
            AppendTextToDescription(CountryRegion.Name);

        AppendTextToDescription(Format(Date2DMY("Start Date", 3)));
    end;

    local procedure AppendTextToDescription(Text: Text[50])
    begin
        if Text = '' then
            exit;

        if Description <> '' then
            Description := Description + ' ';

        Description := Description + Text;
    end;


    procedure CheckForOldRates()
    var
        PerDiemGroup: Record "CEM Per Diem Group";
        PerDiemRates: Record "CEM Per Diem Rate";
        OldPerDiemRatesExist: Boolean;
    begin
        if PerDiemGroup.FindSet() then
            repeat
                SetRange("Per Diem Group Code", PerDiemGroup.Code);
                if FindSet() then
                    repeat
                        PerDiemRates.Copy(Rec);
                        PerDiemRates.SetRange("Destination Country/Region", "Destination Country/Region");
                        if PerDiemRates.FindLast() then
                            if (Today - PerDiemRates."Start Date" > 365) then
                                OldPerDiemRatesExist := true;
                        Rec := PerDiemRates;
                    until Next() = 0;
            until PerDiemGroup.Next() = 0;

        if OldPerDiemRatesExist then
            Message(RatesOlderThanOneYear);
    end;


    procedure CheckForExpiringRates()
    var
        PerDiemGroup: Record "CEM Per Diem Group";
        PerDiemRates: Record "CEM Per Diem Rate";
        RatesExpireSoon: Boolean;
    begin
        if PerDiemGroup.FindSet() then
            repeat
                SetRange("Per Diem Group Code", PerDiemGroup.Code);
                if FindSet() then
                    repeat
                        PerDiemRates.Copy(Rec);
                        PerDiemRates.SetRange("Destination Country/Region", "Destination Country/Region");
                        if PerDiemRates.FindLast() then
                            if (Today - PerDiemRates."Start Date" > 365 - 14) then
                                RatesExpireSoon := true;
                        Rec := PerDiemRates;
                    until Next() = 0;
            until PerDiemGroup.Next() = 0;

        if RatesExpireSoon then
            if Confirm(RatesCouldBeExpiringSoon) then
                PAGE.Run(6086433);
    end;


    procedure AppliedRateIsOlderThanAYear(PerDiem: Record "CEM Per Diem") RateOlderThanOneYear: Boolean
    begin
        SetRange("Per Diem Group Code", PerDiem."Per Diem Group Code");
        SetRange("Destination Country/Region", PerDiem."Destination Country/Region");
        SetRange("Start Date", 0D, DT2Date(PerDiem."Departure Date/Time"));
        if FindLast() then
            if (DT2Date(PerDiem."Departure Date/Time") - "Start Date" > 365) then
                exit(true);
    end;


    procedure GetBreakfastAmount(): Decimal
    begin
        exit(GetMealValue("Breakfast Value"));
    end;


    procedure GetLunchAmount(): Decimal
    begin
        exit(GetMealValue("Lunch Value"));
    end;


    procedure GetDinnerAmount(): Decimal
    begin
        exit(GetMealValue("Dinner Value"));
    end;

    local procedure GetMealValue(MealValueInput: Decimal): Decimal
    begin
        if "Meal Value Method" = "Meal Value Method"::Amount then
            exit(MealValueInput)
        else
            exit(MealValueInput / 100 * "Daily Meal Allowance");
    end;


    procedure GetResidualAfterDeductingMeals(): Decimal
    begin
        exit("Daily Meal Allowance" - GetBreakfastAmount() - GetLunchAmount() - GetDinnerAmount());
    end;
}

