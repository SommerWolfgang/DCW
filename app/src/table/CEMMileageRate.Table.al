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
                    if CheckPostedMileageExistsAfterCurrRate then
                        Error(PostedExistsErrOnValidate, "Vehicle Code", FieldCaption("Vehicle Code"));
            end;
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                if xRec."Start Date" <> 0D then
                    if CheckPostedMileageExistsAfterCurrRate then
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
                    if CheckPostedMileageExistsAfterCurrRate then
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
                    if CheckPostedMileageExistsAfterCurrRate then
                        Error(PostedExistsErrOnValidate, "Rate (LCY)", FieldCaption("Rate (LCY)"));
            end;
        }
        field(6; "New Mileage Year"; Boolean)
        {
            Caption = 'New Mileage Year';

            trigger OnValidate()
            begin
                if CheckPostedMileageExistsAfterCurrRate then
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
                    if CheckPostedMileageExistsAfterCurrRate then
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
        if CheckPostedMileageExistsAfterCurrRate then
            Error(NotAllowedToDelete, TableCaption, "Vehicle Code", Mileage.TableCaption);
    end;

    trigger OnInsert()
    begin
        if CheckPostedMileageExistsAfterCurrRate then
            Error(PostedExistsErrOnInsert, "Start Date");

        CheckMileageToBeRecalculatedExists;
    end;

    trigger OnModify()
    begin
        CheckMileageToBeRecalculatedExists;
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
    var
        Distance: Decimal;
        Previous: Decimal;
        TotalDistance: Decimal;
    begin
        Mileage."Amount (LCY)" := 0;
        InitDetails(Mileage);

        Previous := PreviousTotal(Mileage, IncludeNotPosted);
        Distance := Mileage."Total Distance";
        TotalDistance := Previous + Distance;

        CalcAmtFindingRatesRecursively(
          Mileage, Distance, TotalDistance, Previous, GetMilYearStartDate(Mileage."Vehicle Code", Mileage."Registration Date"));

        if GetCompanyName = CompanyName then
            CheckRfndWithinLimitAndStopRefund(Mileage);
    end;

    local procedure CalcAmtFindingRatesRecursively(var Mileage: Record "CEM Mileage"; var Distance: Decimal; var TotalDistance: Decimal; StartDistance: Decimal; FinancialYearStartDate: Date)
    var
        Rate: Record "CEM Mileage Rate";
        CompanyCarPostingToJobs: Boolean;
        AttendeeRate: Decimal;
        Factor: Decimal;
        MaxDistance: Decimal;
        Previous: Decimal;
    begin
        // SCENARIO                 || REFUNDABLE || INCREASE DISTANCE || AMOUNT ON MILEAGE
        //==================================================================================
        //NO REFUND                 || NO         || YES               || 0
        //PERSOANL CAR              || YES        || YES               || BASED ON CALCULATION
        //COMPANY CAR WITH JOBS     || NO         || NO                || BASED ON CALCULATION
        //COMPANY CAR WITHOUT JOBS  || NO         || NO                || 0

        Previous := StartDistance;
        Factor := 1;

        CompanyCarPostingToJobs := IsCompanyCar(Mileage."Vehicle Code") and (Mileage."Job No." <> '');

        if Mileage."No Refund" and not CompanyCarPostingToJobs then begin
            // No calculations - but manipulate the distance
            Mileage."Amount (LCY)" := 0;
            if IsCompanyCar(Mileage."Vehicle Code") and (Mileage."Job No." = '') then
                InsertDetails(Mileage, '', 0, 0, 0, Previous, Previous)
            else
                InsertDetails(Mileage, '', Distance, 0, 0, Previous, TotalDistance);
        end else begin
            FindRate(Previous, Mileage, Rate, FinancialYearStartDate);
            Mileage.CalcFields("No. of Attendees");
            AttendeeRate := Rate."Attendee Added Rate" * Mileage."No. of Attendees";

            if FindNextRateAndMaxDistance(Rate, TotalDistance, MaxDistance) then begin
                Mileage."Amount (LCY)" :=
                  Round(Mileage."Amount (LCY)" +
                  Factor * (Rate."Rate (LCY)" + AttendeeRate) * (MaxDistance - Previous));
                if CompanyCarPostingToJobs then
                    InsertDetails(
                      Mileage, Rate."Rate ID",
                      0, Factor * (Rate."Rate (LCY)" + AttendeeRate) * (MaxDistance - Previous),
                      (Rate."Rate (LCY)" + AttendeeRate), Previous, StartDistance)
                else
                    InsertDetails(
                      Mileage, Rate."Rate ID",
                      MaxDistance - Previous, Factor * (Rate."Rate (LCY)" + AttendeeRate) * (MaxDistance - Previous),
                      (Rate."Rate (LCY)" + AttendeeRate), Previous, MaxDistance);
                CalcAmtFindingRatesRecursively(Mileage, Distance, TotalDistance, MaxDistance, FinancialYearStartDate);
            end else begin
                Mileage."Amount (LCY)" :=
                  Round(Mileage."Amount (LCY)" +
                   Factor * (Rate."Rate (LCY)" + AttendeeRate) * (TotalDistance - Previous));
                if CompanyCarPostingToJobs then
                    InsertDetails(
                      Mileage, Rate."Rate ID", 0,
                      Factor * (Rate."Rate (LCY)" + AttendeeRate) * (TotalDistance - Previous),
                      (Rate."Rate (LCY)" + AttendeeRate), Previous, StartDistance)
                else
                    InsertDetails(
                      Mileage, Rate."Rate ID", TotalDistance - Previous,
                      Factor * (Rate."Rate (LCY)" + AttendeeRate) * (TotalDistance - Previous),
                      (Rate."Rate (LCY)" + AttendeeRate), Previous, TotalDistance);
            end;
        end;
    end;

    local procedure PreviousTotal(Mileage: Record "CEM Mileage"; IncludeNotPosted: Boolean) Distance: Decimal
    var
        Company: Record Company;
        AboutEM: Codeunit "CEM About Expense Management";
        Core: Codeunit "CSC Core";
        EndDate: Date;
        StartDate: Date;
    begin
        StartDate := GetMilYearStartDate(Mileage."Vehicle Code", Mileage."Registration Date");
        if GetMilYearEndDate("Vehicle Code", StartDate) <> 0D then
            EndDate := CalcDate('<-1D>', GetMilYearEndDate("Vehicle Code", StartDate));

        if GetCalcAcrossCompanies then begin
            if Company.FindSet then
                repeat
                    if Core.IsAppActiveInCompany(AboutEM.ProductCode, Company.Name) then
                        Distance := Distance + GetTotalDistanceInCompany(Company.Name, Mileage, IncludeNotPosted, StartDate, EndDate);
                until Company.Next = 0;
        end else
            Distance := GetTotalDistanceInCompany(GetCompanyName, Mileage, IncludeNotPosted, StartDate, EndDate);
    end;

    local procedure FindRate(StartDistance: Decimal; Mileage: Record "CEM Mileage"; var Rate: Record "CEM Mileage Rate"; FinancialYearStartDate: Date)
    var
        Math: Codeunit "CEM Math";
    begin
        Rate.ChangeCompany(GetCompanyName);
        Rate.SetRange("Vehicle Code", Mileage."Vehicle Code");
        Rate.SetRange("Start Date", FinancialYearStartDate, Mileage."Registration Date");
        Rate.SetFilter("Starting Distance", '<=%1', Math.Max(StartDistance, 0));
        Rate.FindLast;
    end;

    local procedure FindNextRateAndMaxDistance(var Rate: Record "CEM Mileage Rate"; TotalDistance: Decimal; var MaxDistance: Decimal): Boolean
    var
        NextRate: Record "CEM Mileage Rate";
        MilYearEndDate: Date;
    begin
        MilYearEndDate := GetMilYearEndDate(Rate."Vehicle Code", Rate."Start Date");

        NextRate.ChangeCompany(GetCompanyName);
        NextRate.CopyFilters(Rate);
        if MilYearEndDate = 0D then
            NextRate.SetFilter("Start Date", '>=%1', Rate."Start Date")
        else
            NextRate.SetFilter("Start Date", '>=%1&<%2', Rate."Start Date", MilYearEndDate);
        NextRate.SetFilter("Starting Distance", '>%1', Rate."Starting Distance");
        if NextRate.FindFirst then
            if TotalDistance > NextRate."Starting Distance" then begin
                MaxDistance := NextRate."Starting Distance";
                exit(true); // The distance spans on more than one rate
            end;

        exit(false); // The rate applies to the whole distance
    end;

    local procedure InsertDetails(Mileage: Record "CEM Mileage"; RateID: Code[10]; Distance: Decimal; Amount: Decimal; ActualRate: Decimal; FromDistance: Decimal; ToDistance: Decimal)
    var
        MileageDetail: Record "CEM Mileage Detail";
    begin
        MileageDetail.ChangeCompany(GetCompanyName);
        MileageDetail."Mileage Entry No." := Mileage."Entry No.";
        MileageDetail.SetRange("Mileage Entry No.", MileageDetail."Mileage Entry No.");
        if MileageDetail.FindLast then;

        MileageDetail."Detail Entry No." := MileageDetail."Detail Entry No." + 1;
        MileageDetail."Continia User ID" := Mileage."Continia User ID";
        MileageDetail."Registration Date" := Mileage."Registration Date";
        MileageDetail."Rate ID" := RateID;
        MileageDetail.Distance := Distance;
        MileageDetail.Rate := ActualRate;
        MileageDetail."Amount (LCY)" := Amount;
        MileageDetail."Vehicle Code" := Mileage."Vehicle Code";
        MileageDetail.Posted := false;
        MileageDetail."From Distance" := FromDistance;
        MileageDetail."To Distance" := ToDistance;
        MileageDetail.Reimbursed := false;
        MileageDetail."Reimbursement Method" := Mileage."Reimbursement Method";
        MileageDetail.Insert;
    end;

    local procedure InitDetails(Mileage: Record "CEM Mileage")
    var
        MileageDetail: Record "CEM Mileage Detail";
    begin
        MileageDetail.ChangeCompany(GetCompanyName);
        MileageDetail.SetRange("Mileage Entry No.", Mileage."Entry No.");
        MileageDetail.DeleteAll;
    end;

    local procedure GetTotalDistanceInCompany(CompName: Text[50]; Mileage: Record "CEM Mileage"; IncludeNotPosted: Boolean; PeriodStartDate: Date; PeriodEndDate: Date): Decimal
    var
        PostedMileageDetails: Record "CEM Mileage Detail";
        UnpostedMileageDetails: Record "CEM Mileage Detail";
    begin
        PostedMileageDetails.ChangeCompany(CompName);
        PostedMileageDetails.SetCurrentKey("Continia User ID", "Registration Date", Posted);
        PostedMileageDetails.SetRange("Continia User ID", Mileage."Continia User ID");
        PostedMileageDetails.SetRange(Posted, true);
        if PeriodEndDate <> 0D then
            PostedMileageDetails.SetFilter("Registration Date", '>=%1&<=%2', PeriodStartDate, PeriodEndDate)
        else
            PostedMileageDetails.SetFilter("Registration Date", '>=%1', PeriodStartDate);
        PostedMileageDetails.CalcSums(Distance);

        if IncludeNotPosted then begin
            UnpostedMileageDetails.ChangeCompany(CompName);
            UnpostedMileageDetails.SetCurrentKey("Continia User ID", "Registration Date", Posted);
            UnpostedMileageDetails.SetRange("Continia User ID", Mileage."Continia User ID");
            UnpostedMileageDetails.SetRange(Posted, false);
            UnpostedMileageDetails.SetFilter("Mileage Entry No.", '<%1', Mileage."Entry No."); // Not perfect in multicompany
            if PeriodEndDate <> 0D then
                UnpostedMileageDetails.SetFilter("Registration Date", '>=%1&<=%2', PeriodStartDate, PeriodEndDate)
            else
                UnpostedMileageDetails.SetFilter("Registration Date", '>=%1', PeriodStartDate);
            UnpostedMileageDetails.CalcSums(Distance);
        end else
            UnpostedMileageDetails.Distance := 0;

        exit(UnpostedMileageDetails.Distance + PostedMileageDetails.Distance);
    end;

    local procedure GetMilYearStartDate(VehicleCode: Code[20]; CheckDate: Date): Date
    var
        Rate: Record "CEM Mileage Rate";
        ShowError: Boolean;
    begin
        ShowError := not IsCompanyCar(VehicleCode);

        Rate.ChangeCompany(GetCompanyName);
        Rate.SetRange("Vehicle Code", VehicleCode);
        Rate.SetFilter("Start Date", '<=%1', CheckDate);
        Rate.SetRange("New Mileage Year", true);
        if CompanyName = GetCompanyName then begin
            if not Rate.FindLast and ShowError then
                Error(NoMilRateFoundBeforeError, VehicleCode, CheckDate);
        end else
            if Rate.FindLast then;

        exit(Rate."Start Date");
    end;

    local procedure GetMilYearEndDate(VehicleCode: Code[20]; CheckDate: Date): Date
    var
        Rate: Record "CEM Mileage Rate";
    begin
        Rate.ChangeCompany(GetCompanyName);
        Rate.SetRange("Vehicle Code", VehicleCode);
        Rate.SetFilter("Start Date", '>%1', CheckDate);
        Rate.SetRange("New Mileage Year", true);
        if Rate.FindLast then
            exit(Rate."Start Date");
    end;


    procedure RecalculateMileageRate()
    var
        Mileage: Record "CEM Mileage";
    begin
        Mileage.ChangeCompany(GetCompanyName);
        Mileage.SetCurrentKey(Posted);
        Mileage.SetRange(Posted, false);
        Mileage.SetRange("Vehicle Code", "Vehicle Code");
        Mileage.SetFilter("Registration Date", '>=%1', "Start Date");
        if not Mileage.IsEmpty then begin
            Mileage.LockTable;
            if Mileage.FindSet(true, false) then
                repeat
                    CalcMileageDetails(Mileage, true);
                    Mileage.Modify;
                until Mileage.Next = 0;
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

        if Company.FindSet then
            repeat
                PermissionGranted := EMSetup.ChangeCompany(Company.Name) and EMSetup.ReadPermission;
                PermissionGranted := PermissionGranted and (Mileage.ChangeCompany(Company.Name) and Mileage.ReadPermission and Mileage.WritePermission);
                PermissionGranted := PermissionGranted and (MileageRate.ChangeCompany(Company.Name) and MileageRate.ReadPermission);

                if PermissionGranted then
                    if EMSetup.Get and (not Mileage.IsEmpty) then
                        if MileageRate.FindSet then
                            repeat
                                MileageRate.SetGlobalVars(Company.Name, EMSetup."Calc. mil. across companies");
                                MileageRate.RecalculateMileageRate;
                            until MileageRate.Next = 0;

            until Company.Next = 0;
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

        if not EMSetup.Get then
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
        if not Vehicle.FindSet then
            exit;

        repeat
            if Vehicle.HasBeenUsedWithinAYear then begin
                SetRange("Vehicle Code", Vehicle.Code);
                if FindLast then
                    if (Today - "Start Date" > 365) then
                        OldMileageRatesExists := true;
            end;
        until (Vehicle.Next = 0) or OldMileageRatesExists;

        if OldMileageRatesExists then
            Message(RatesOlderThanOneYear);
    end;


    procedure CheckForExpiringRates()
    var
        Vehicle: Record "CEM Vehicle";
        RatesExpireSoon: Boolean;
    begin
        if not Vehicle.FindSet then
            exit;

        repeat
            if Vehicle.HasBeenUsedWithinAYear then begin
                SetRange("Vehicle Code", Vehicle.Code);
                if FindLast then
                    if (Today - "Start Date" > 365 - 14) then
                        RatesExpireSoon := true;
            end;
        until (Vehicle.Next = 0) or RatesExpireSoon;

        if RatesExpireSoon then
            if Confirm(RatesCouldBeExpiringSoon) then
                PAGE.Run(6086376);
    end;


    procedure AppliedRateIsOlderThanAYear(Mileage: Record "CEM Mileage") RateOlderThanOneYear: Boolean
    begin
        SetRange("Vehicle Code", Mileage."Vehicle Code");
        SetRange("Start Date", 0D, Mileage."Registration Date");
        if FindLast then
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
    var
        EMComment: Record "CEM Comment";
        CompanyPolicy: Record "CEM Company Policy";
        EMSetup: Record "CEM Expense Management Setup";
        MileageDetail: Record "CEM Mileage Detail";
        GLSetup: Record "General Ledger Setup";
        CmtMgt: Codeunit "CEM Comment Mgt.";
        GotSetup: Boolean;
        EndDate: Date;
        StartDate: Date;
        BalanceDistance: Decimal;
        Diff: Decimal;
    begin
        // Delete previous comment.
        CmtMgt.DeleteComment(DATABASE::"CEM Mileage", 0, '', Mileage."Entry No.", EMComment.Importance::Information, 'PARTIALREFUND', false);

        if not CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Mileage", Mileage."Continia User ID", Mileage."Vehicle Code") then
            exit(false);

        CompanyPolicy.GetTimeIntervalStartAndEndDate(Mileage."Registration Date", StartDate, EndDate);
        BalanceDistance := Mileage.GetMilBalOnUserForDateInterval(StartDate, EndDate);
        if BalanceDistance > CompanyPolicy.Distance then begin
            MileageDetail.SetRange("Mileage Entry No.", Mileage."Entry No.");
            if MileageDetail.FindLast then begin
                if CompanyPolicy.Distance < MileageDetail.Distance then begin
                    MileageDetail.Distance := CompanyPolicy.Distance;
                    MileageDetail."Amount (LCY)" := MileageDetail.Distance * MileageDetail.Rate;
                    MileageDetail.Modify(true);
                end else begin
                    // Reduce current Detail to 0 and find another one.
                    Diff := CompanyPolicy.Distance - MileageDetail.Distance;

                    MileageDetail.Distance := 0;
                    MileageDetail."Amount (LCY)" := 0;
                    MileageDetail.Modify(true);

                    // Find another detail on the same mileage, otherwise give up
                    MileageDetail.SetRange("Mileage Entry No.", Mileage."Entry No.");
                    MileageDetail.SetFilter(Distance, '<%1', 0);
                    if MileageDetail.FindLast then begin
                        if MileageDetail.Distance > Diff then begin
                            MileageDetail.Distance := Diff;
                            MileageDetail."Amount (LCY)" := MileageDetail.Distance * MileageDetail.Rate;
                            MileageDetail.Modify(true);
                        end;
                    end;
                end;
            end;

            // Maintain mileage amount
            Mileage."Amount (LCY)" := MileageDetail."Amount (LCY)";

            GLSetup.Get;
            EMSetup.Get;
            CmtMgt.AddComment(DATABASE::"CEM Mileage", 0, '', Mileage."Entry No.", EMComment.Importance::Information, 'PARTIALREFUND',
              StrSubstNo(MilPartialRefundTxt, "Vehicle Code", Format(CompanyPolicy.Distance), EMSetup."Distance Unit"), false);
        end;
    end;
}

