table 6086370 "CEM Mileage Rate"
{
    Caption = 'Mileage Rate';
    DataCaptionFields = "Vehicle Code", "Start Date", "Rate (LCY)";
    Permissions = TableData "CEM Mileage Detail" = rimd;

    fields
    {
        field(1; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
            NotBlank = true;
            TableRelation = "CEM Vehicle";

            trigger OnValidate()
            begin
                if xRec."Vehicle Code" <> '' then
                    if CheckPostedMileageExistsAfterCurrRate() then
                        Error(PostedExistsErrOnValidate, "Vehicle Code", FieldCaption("Vehicle Code"));
            end;
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                if xRec."Start Date" <> 0D then
                    if CheckPostedMileageExistsAfterCurrRate() then
                        Error(PostedExistsErrOnValidate, "Start Date", FieldCaption("Start Date"));
            end;
        }
        field(4; "Starting Distance"; Decimal)
        {
            Caption = 'Starting Distance';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if xRec."Starting Distance" <> 0 then
                    if CheckPostedMileageExistsAfterCurrRate() then
                        Error(PostedExistsErrOnValidate, "Starting Distance", FieldCaption("Starting Distance"));
            end;
        }
        field(5; "Rate (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rate (LCY)';

            trigger OnValidate()
            begin
                if xRec."Rate (LCY)" <> 0 then
                    if CheckPostedMileageExistsAfterCurrRate() then
                        Error(PostedExistsErrOnValidate, "Rate (LCY)", FieldCaption("Rate (LCY)"));
            end;
        }
        field(6; "New Mileage Year"; Boolean)
        {
            Caption = 'New Mileage Year';

            trigger OnValidate()
            begin
                if CheckPostedMileageExistsAfterCurrRate() then
                    Error(PostedExistsErrOnValidate, "New Mileage Year", FieldCaption("New Mileage Year"));
            end;
        }
        field(10; "Rate ID"; Code[10])
        {
            Caption = 'Rate ID';
            TableRelation = "CEM Mileage Rate ID";
        }
        field(11; "Attendee Added Rate"; Decimal)
        {
            Caption = 'Attendee Added Rate';

            trigger OnValidate()
            begin
                if xRec."Attendee Added Rate" <> 0 then
                    if CheckPostedMileageExistsAfterCurrRate() then
                        Error(PostedExistsErrOnValidate, "Attendee Added Rate", FieldCaption("Attendee Added Rate"));
            end;
        }
    }

    keys
    {
        key(Key1; "Vehicle Code", "Start Date", "Starting Distance")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Code", "Start Date", "New Mileage Year")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Mileage: Record "CEM Mileage";
    begin
        if CheckPostedMileageExistsAfterCurrRate() then
            Error(NotAllowedToDelete, TableCaption, "Vehicle Code", Mileage.TableCaption);
    end;

    trigger OnInsert()
    begin
        if CheckPostedMileageExistsAfterCurrRate() then
            Error(PostedExistsErrOnInsert, "Start Date");

        CheckMileageToBeRecalculatedExists();
    end;

    trigger OnModify()
    begin
        CheckMileageToBeRecalculatedExists();
    end;

    var
        CalcMilAcrossCompanies: Boolean;
        MilPartialRefundTxt: Label 'Mileage partially refunded. Vehicle %1 can only refund %2 %3. The difference is not refundable.';
        NoMilRateFoundBeforeError: Label 'No mileage rate was found for vehicle code %1, starting before %2.';
        NotAllowedToDelete: Label 'It is not allowed to delete %1 %2, because %3 has posted transactions.';
        PostedExistsErrOnInsert: Label 'One or more mileage have been posted after %1 and therefore the rate cannot be created.';
        PostedExistsErrOnValidate: Label 'One or more mileage have been posted after %1 and %2 can therefore not be changed.';
        RatesCouldBeExpiringSoon: Label 'Mileage rates should be updated every year.\Do you want to review them now?';
        RatesOlderThanOneYear: Label 'The mileage rates are more than a year old.\Please consider updating them.';
        RecalculateDetails: Label 'The mileage details need to be updated.';
        CmpNameGlobal: Text[30];


    procedure CalcMileageDetails(var Mileage: Record "CEM Mileage"; IncludeNotPosted: Boolean)
    begin
    end;

    procedure RecalculateMileageRate()
    var
        Mileage: Record "CEM Mileage";
    begin
        Mileage.ChangeCompany(GetCompanyName());
        Mileage.SetCurrentKey(Posted);
        Mileage.SetRange(Posted, false);
        Mileage.SetRange("Vehicle Code", "Vehicle Code");
        Mileage.SetFilter("Registration Date", '>=%1', "Start Date");
        if not Mileage.IsEmpty then begin
            Mileage.LockTable();
            if Mileage.FindSet(true, false) then
                repeat
                    CalcMileageDetails(Mileage, true);
                    Mileage.Modify();
                until Mileage.Next() = 0;
        end;
    end;


    procedure RecalcMilAcrossComp()
    var
        EMSetup: Record "CEM Expense Management Setup";
        Mileage: Record "CEM Mileage";
        MileageRate: Record "CEM Mileage Rate";
        Company: Record Company;
        PermissionGranted: Boolean;
    begin
        if not Company.ReadPermission then
            exit;

        if Company.FindSet() then
            repeat
                PermissionGranted := EMSetup.ChangeCompany(Company.Name) and EMSetup.ReadPermission;
                PermissionGranted := PermissionGranted and (Mileage.ChangeCompany(Company.Name) and Mileage.ReadPermission and Mileage.WritePermission);
                PermissionGranted := PermissionGranted and (MileageRate.ChangeCompany(Company.Name) and MileageRate.ReadPermission);

                if PermissionGranted then
                    if EMSetup.Get() and (not Mileage.IsEmpty) then
                        if MileageRate.FindSet() then
                            repeat
                                MileageRate.SetGlobalVars(Company.Name, EMSetup."Calc. mil. across companies");
                                MileageRate.RecalculateMileageRate();
                            until MileageRate.Next() = 0;

            until Company.Next() = 0;
    end;


    procedure SetGlobalVars(CmpName: Text[30]; CalcArcossCmp: Boolean)
    begin
        CmpNameGlobal := CmpName;
        CalcMilAcrossCompanies := CalcArcossCmp;
    end;

    local procedure GetCompanyName(): Text[30]
    begin
        if CmpNameGlobal <> '' then
            exit(CmpNameGlobal)
        else
            exit(CompanyName);
    end;

    local procedure GetCalcAcrossCompanies(): Boolean
    var
        EMSetup: Record "CEM Expense Management Setup";
    begin
        if CmpNameGlobal <> '' then
            exit(CalcMilAcrossCompanies);

        if not EMSetup.Get() then
            exit(false);

        exit(EMSetup."Calc. mil. across companies");
    end;

    local procedure IsCompanyCar(VehicleCode: Code[20]): Boolean
    var
        Vehicle: Record "CEM Vehicle";
    begin
        if Vehicle.Get(VehicleCode) then
            exit(Vehicle."Company Car");
    end;


    procedure CheckForOldRates()
    var
        Vehicle: Record "CEM Vehicle";
        OldMileageRatesExists: Boolean;
    begin
        if not Vehicle.FindSet() then
            exit;

        repeat
            if Vehicle.HasBeenUsedWithinAYear() then begin
                SetRange("Vehicle Code", Vehicle.Code);
                if FindLast() then
                    if (Today - "Start Date" > 365) then
                        OldMileageRatesExists := true;
            end;
        until (Vehicle.Next() = 0) or OldMileageRatesExists;

        if OldMileageRatesExists then
            Message(RatesOlderThanOneYear);
    end;


    procedure CheckForExpiringRates()
    var
        Vehicle: Record "CEM Vehicle";
        RatesExpireSoon: Boolean;
    begin
        if not Vehicle.FindSet() then
            exit;

        repeat
            if Vehicle.HasBeenUsedWithinAYear() then begin
                SetRange("Vehicle Code", Vehicle.Code);
                if FindLast() then
                    if (Today - "Start Date" > 365 - 14) then
                        RatesExpireSoon := true;
            end;
        until (Vehicle.Next() = 0) or RatesExpireSoon;

        if RatesExpireSoon then
            if Confirm(RatesCouldBeExpiringSoon) then
                PAGE.Run(6086376);
    end;


    procedure AppliedRateIsOlderThanAYear(Mileage: Record "CEM Mileage") RateOlderThanOneYear: Boolean
    begin
        SetRange("Vehicle Code", Mileage."Vehicle Code");
        SetRange("Start Date", 0D, Mileage."Registration Date");
        if FindLast() then
            if (Mileage."Registration Date" - "Start Date" > 365) then
                exit(true);
    end;

    local procedure CheckPostedMileageExistsAfterCurrRate(): Boolean
    var
        Mileage: Record "CEM Mileage";
    begin
        if "Start Date" = 0D then
            exit;

        Mileage.SetCurrentKey(Posted);
        Mileage.SetRange(Posted, true);
        Mileage.SetRange("Vehicle Code", "Vehicle Code");
        Mileage.SetFilter("Registration Date", '>=%1', "Start Date");
        exit(not Mileage.IsEmpty);
    end;

    local procedure CheckMileageToBeRecalculatedExists()
    var
        Mileage: Record "CEM Mileage";
    begin
        Mileage.SetCurrentKey(Posted);
        Mileage.SetRange(Posted, false);
        Mileage.SetRange("Vehicle Code", "Vehicle Code");
        Mileage.SetFilter("Registration Date", '>=%1', "Start Date");
        if not Mileage.IsEmpty then
            Message(RecalculateDetails);
    end;


    procedure CheckRfndWithinLimitAndStopRefund(var Mileage: Record "CEM Mileage"): Boolean
    begin
    end;
}