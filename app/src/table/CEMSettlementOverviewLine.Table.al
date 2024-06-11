table 6086340 "CEM Settlement Overview Line"
{
    Caption = 'Settlement Overview Line';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "CEM Expense Header"."No.";
        }
        field(4; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
            TableRelation = if ("Table ID" = const(6086320)) "CEM Expense"
            else
            if ("Table ID" = const(6086338)) "CEM Mileage";
        }
        field(5; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(9; "Document Date"; Date)
        {
            Caption = 'Document Date';
            NotBlank = true;
        }
        field(10; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(12; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(14; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = if ("Table ID" = const(6086320)) "CEM Expense Type"
            else
            if ("Table ID" = const(6086338)) "CEM Vehicle";
        }
        field(15; Details; Text[250])
        {
            Caption = 'Details';
        }
        field(16; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(17; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(210; "No Refund"; Boolean)
        {
            Caption = 'No Refund';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ConfirmDetachExpenseMultiple: Label 'Do you want to detach %1 expenses from this settlement?';
        ConfirmDetachExpenseSingle: Label 'Do you want to detach the expense from this settlement?';
        ConfirmDetachMileageMultiple: Label 'Do you want to detach %1 mileage from this settlement?';
        ConfirmDetachMileageSingle: Label 'Do you want to detach the mileage from this settlement?';
        ConfirmDetachPerDiemMultiple: Label 'Do you want to detach %1 per diems from this settlement?';
        ConfirmDetachPerDiemSingle: Label 'Do you want to detach the per diem from this settlement?';
        NoExpInSelection: Label 'Please select one or more expenses to detach.';
        NoMilInSelection: Label 'Please select one or more mileage to detach.';
        NoPerDiemInSelection: Label 'Please select one or more per diems to detach.';
        NotSupported: Label 'This functionality is not supported for expenses.';


    procedure LoadSettlements(DocumentNo: Code[20]; var SttlOverviewTmp: Record "CEM Settlement Overview Line" temporary)
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        PosRecTmp: Record "CEM Settlement Overview Line" temporary;
    begin
        PosRecTmp := Rec;

        SttlOverviewTmp.Reset();
        SttlOverviewTmp.DeleteAll();

        if DocumentNo = '' then
            exit;

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", DocumentNo);
        if Expense.FindSet() then
            repeat
                SttlOverviewTmp.Init();
                SttlOverviewTmp."Table ID" := DATABASE::"CEM Expense";
                SttlOverviewTmp."Document Type" := SttlOverviewTmp."Document Type"::Settlement;
                SttlOverviewTmp."Document No." := DocumentNo;
                SttlOverviewTmp."Doc. Ref. No." := Expense."Entry No.";
                SttlOverviewTmp."Continia User ID" := Expense."Continia User ID";
                SttlOverviewTmp.Code := Expense."Expense Type";
                SttlOverviewTmp.Description := Expense.Description;
                SttlOverviewTmp."Description 2" := Expense."Description 2";
                SttlOverviewTmp."Document Date" := Expense."Document Date";
                SttlOverviewTmp."Amount (LCY)" := Expense."Amount (LCY)";
                SttlOverviewTmp."Global Dimension 1 Code" := Expense."Global Dimension 1 Code";
                SttlOverviewTmp."Global Dimension 2 Code" := Expense."Global Dimension 2 Code";
                SttlOverviewTmp."Job No." := Expense."Job No.";
                SttlOverviewTmp."Job Task No." := Expense."Job Task No.";
                SttlOverviewTmp.Details := Expense.GetOverviewDetails();
                SttlOverviewTmp."No Refund" := Expense."No Refund";
                SttlOverviewTmp.Insert();
            until Expense.Next() = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", DocumentNo);
        if Mileage.FindSet() then
            repeat
                SttlOverviewTmp.Init();
                SttlOverviewTmp."Table ID" := DATABASE::"CEM Mileage";
                SttlOverviewTmp."Document Type" := SttlOverviewTmp."Document Type"::Settlement;
                SttlOverviewTmp."Document No." := DocumentNo;
                SttlOverviewTmp."Doc. Ref. No." := Mileage."Entry No.";
                SttlOverviewTmp."Continia User ID" := Mileage."Continia User ID";
                SttlOverviewTmp.Code := Mileage."Vehicle Code";
                SttlOverviewTmp.Description := Mileage.Description;
                SttlOverviewTmp."Document Date" := Mileage."Registration Date";
                SttlOverviewTmp."Amount (LCY)" := Mileage."Amount (LCY)";
                SttlOverviewTmp."Global Dimension 1 Code" := Mileage."Global Dimension 1 Code";
                SttlOverviewTmp."Global Dimension 2 Code" := Mileage."Global Dimension 2 Code";
                SttlOverviewTmp."Job No." := Mileage."Job No.";
                SttlOverviewTmp."Job Task No." := Mileage."Job Task No.";
                SttlOverviewTmp.Details := Mileage.GetOverviewDetails();
                SttlOverviewTmp."No Refund" := Mileage."No Refund";
                SttlOverviewTmp.Insert();
            until Mileage.Next() = 0;


        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", DocumentNo);
        if PerDiem.FindSet() then
            repeat
                PerDiem.CalcFields("Amount (LCY)");
                SttlOverviewTmp.Init();
                SttlOverviewTmp."Table ID" := DATABASE::"CEM Per Diem";
                SttlOverviewTmp."Document Type" := SttlOverviewTmp."Document Type"::Settlement;
                SttlOverviewTmp."Document No." := DocumentNo;
                SttlOverviewTmp."Doc. Ref. No." := PerDiem."Entry No.";
                SttlOverviewTmp."Continia User ID" := PerDiem."Continia User ID";
                SttlOverviewTmp.Code := PerDiem."Per Diem Group Code";
                SttlOverviewTmp.Description := PerDiem.Description;
                SttlOverviewTmp."Description 2" := PerDiem."Description 2";
                SttlOverviewTmp."Document Date" := PerDiem."Posting Date";
                SttlOverviewTmp."Amount (LCY)" := PerDiem."Amount (LCY)";
                SttlOverviewTmp."Global Dimension 1 Code" := PerDiem."Global Dimension 1 Code";
                SttlOverviewTmp."Global Dimension 2 Code" := PerDiem."Global Dimension 2 Code";
                SttlOverviewTmp."Job No." := PerDiem."Job No.";
                SttlOverviewTmp."Job Task No." := PerDiem."Job Task No.";
                SttlOverviewTmp.Details := PerDiem.GetOverviewDetails();
                SttlOverviewTmp.Insert();
            until PerDiem.Next() = 0;
        if not SttlOverviewTmp.Get(PosRecTmp."Table ID", PosRecTmp."Document Type", PosRecTmp."Document No.", PosRecTmp."Doc. Ref. No.") then
            if SttlOverviewTmp.FindFirst() then;
    end;


    procedure ShowAttachments()
    var
        EMAttachment: Record "CEM Attachment";
    begin
        EMAttachment.SetRange("Table ID", "Table ID");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", "Doc. Ref. No.");
        PAGE.RunModal(0, EMAttachment);
    end;


    procedure ShowDimensions()
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.LookupDimensions(false);
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.LookupDimensions(false);
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.LookupDimensions(false);
                end;
        end;
    end;


    procedure ShowExtraFields()
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.LookupExtraFields(false);
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.LookupExtraFields(false);
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.LookupExtraFields(false);
                end;
        end;
    end;


    procedure ShowAttendees()
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.DrillDownAttendees();
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.DrillDownAttendees();
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.DrillDownAttendees();
                end;
        end;
    end;


    procedure OpenDocumentCard()
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.OpenDocumentCard();
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.OpenDocumentCard();
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.OpenDocumentCard();
                end;
        end;
    end;


    procedure SplitAndAllocate()
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    Expense.SplitAndAllocate();
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.SplitAndAllocate();
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.SplitAndAllocate();
                end;
        end;
    end;


    procedure HasComments(): Boolean
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                begin
                    Expense.Get("Doc. Ref. No.");
                    exit(Expense.HasExpenseComment() or Expense.HasApprovalComment());
                end;

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    exit(Mileage.HasMileageComment() or Mileage.HasApprovalComment());
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    exit(PerDiem.HasPerDiemComment() or PerDiem.HasApprovalComment());
                end;
        end;
    end;


    procedure LookupComments()
    begin
    end;


    procedure DetachExpFromSettlement(var SttlOverviewLine: Record "CEM Settlement Overview Line")
    var
        Expense: Record "CEM Expense";
        ConfirmText: Text[250];
    begin
        SttlOverviewLine.SetRange("Table ID", DATABASE::"CEM Expense");
        if SttlOverviewLine.Count = 0 then
            Error(NoExpInSelection);

        if SttlOverviewLine.Count = 1 then
            ConfirmText := ConfirmDetachExpenseSingle
        else
            ConfirmText := ConfirmDetachExpenseMultiple;

        if Confirm(ConfirmText, false, SttlOverviewLine.Count) then begin
            SttlOverviewLine.FindFirst();
            repeat
                Expense.Get("Doc. Ref. No.");
                Expense.Validate("Settlement No.", '');
                Expense.Modify(true);
            until SttlOverviewLine.Next() = 0;
        end;
    end;


    procedure DetachMilFromSettlement(var SttlOverviewLine: Record "CEM Settlement Overview Line")
    var
        Mileage: Record "CEM Mileage";
        ConfirmText: Text[1024];
    begin
        SttlOverviewLine.SetRange("Table ID", DATABASE::"CEM Mileage");
        if SttlOverviewLine.Count = 0 then
            Error(NoMilInSelection);

        if SttlOverviewLine.Count = 1 then
            ConfirmText := ConfirmDetachMileageSingle
        else
            ConfirmText := StrSubstNo(ConfirmDetachMileageMultiple, SttlOverviewLine.Count);

        if Confirm(ConfirmText) then
            if SttlOverviewLine.FindSet() then
                repeat
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.Validate("Settlement No.", '');
                    Mileage.Modify(true);
                until SttlOverviewLine.Next() = 0;
    end;


    procedure DetachPerDiemFromSettlement(var SttlOverviewLine: Record "CEM Settlement Overview Line")
    var
        PerDiem: Record "CEM Per Diem";
        ConfirmText: Text[1024];
    begin
        SttlOverviewLine.SetRange("Table ID", DATABASE::"CEM Per Diem");
        if SttlOverviewLine.Count = 0 then
            Error(NoPerDiemInSelection);

        if SttlOverviewLine.Count = 1 then
            ConfirmText := ConfirmDetachPerDiemSingle
        else
            ConfirmText := StrSubstNo(ConfirmDetachPerDiemMultiple, SttlOverviewLine.Count);

        if Confirm(ConfirmText) then
            if SttlOverviewLine.FindSet() then
                repeat
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.Validate("Settlement No.", '');
                    PerDiem.Modify(true);
                until SttlOverviewLine.Next() = 0;
    end;


    procedure ShowDetails()
    var
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                Error(NotSupported);

            DATABASE::"CEM Mileage":
                begin
                    Mileage.Get("Doc. Ref. No.");
                    Mileage.ShowDetails();
                end;

            DATABASE::"CEM Per Diem":
                begin
                    PerDiem.Get("Doc. Ref. No.");
                    PerDiem.ShowDetails();
                end;
        end;
    end;
}

