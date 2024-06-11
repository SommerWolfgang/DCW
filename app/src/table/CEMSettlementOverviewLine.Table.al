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
    procedure LoadSettlements(DocumentNo: Code[20]; var SttlOverviewTmp: Record "CEM Settlement Overview Line" temporary)
    begin
    end;

    procedure ShowAttachments()
    begin
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
    begin
    end;

    procedure DetachMilFromSettlement(var SttlOverviewLine: Record "CEM Settlement Overview Line")
    begin
    end;

    procedure DetachPerDiemFromSettlement(var SttlOverviewLine: Record "CEM Settlement Overview Line")
    begin
    end;

    procedure ShowDetails()
    begin
    end;
}