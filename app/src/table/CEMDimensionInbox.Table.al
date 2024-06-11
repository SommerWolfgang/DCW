table 6086362 "CEM Dimension Inbox"
{
    Caption = 'EM Dimension Inbox';

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
        }
        field(4; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
            TableRelation = IF ("Table ID" = CONST(6086323)) "CEM Expense Inbox"
            ELSE
            IF ("Table ID" = CONST(6086353)) "CEM Mileage Inbox";
        }
        field(10; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
            ValidateTableRelation = false;
        }
        field(11; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
            ValidateTableRelation = false;
        }
        field(12; "Field Code"; Code[20])
        {
            Caption = 'Field Name';
            TableRelation = "CEM Field Type";
            ValidateTableRelation = false;
        }
        field(13; "Field Value"; Text[250])
        {
            Caption = 'Field Value';
            TableRelation = "CEM Lookup Value".Code WHERE("Field Type Code" = FIELD("Field Code"));
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", "Field Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen;
        ClearError;
        UpdateRecordGlobalDimValue("Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", '');
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        ClearError;
        UpdateRecordGlobalDimValue("Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", "Dimension Value Code");
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
        ClearError;
        UpdateRecordGlobalDimValue("Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Dimension Code", "Dimension Value Code");
    end;

    var
        Text001: Label '%1 %2 already %3.';

    local procedure TestStatusOpen()
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
        PerDiemInbox: Record "CEM Per Diem Inbox";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense Inbox":
                begin
                    ExpenseInbox.Get("Doc. Ref. No.");
                    if ExpenseInbox.Status = ExpenseInbox.Status::Accepted then
                        Error(Text001, ExpenseInbox.TableCaption, ExpenseInbox."Entry No.", ExpenseInbox.Status);
                end;

            DATABASE::"CEM Mileage Inbox":
                begin
                    MileageInbox.Get("Doc. Ref. No.");
                    if MileageInbox.Status = MileageInbox.Status::Accepted then
                        Error(Text001, MileageInbox.TableCaption, MileageInbox."Entry No.", MileageInbox.Status);
                end;

            DATABASE::"CEM Per Diem Inbox":
                begin
                    PerDiemInbox.Get("Doc. Ref. No.");
                    if PerDiemInbox.Status = PerDiemInbox.Status::Accepted then
                        Error(Text001, PerDiemInbox.TableCaption, PerDiemInbox."Entry No.", PerDiemInbox.Status);
                end;

            DATABASE::"CEM Expense Header Inbox":
                begin
                    ExpHeaderInbox.Get("Doc. Ref. No.");
                    if ExpHeaderInbox.Status = ExpHeaderInbox.Status::Accepted then
                        Error(Text001, ExpHeaderInbox.TableCaption, ExpHeaderInbox."Entry No.", ExpHeaderInbox.Status);
                end;
        end;
    end;

    local procedure ClearError()
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
        PerDiemInbox: Record "CEM Per Diem Inbox";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense Inbox":
                begin
                    ExpenseInbox.Get("Doc. Ref. No.");
                    if ExpenseInbox.Status = ExpenseInbox.Status::Error then begin
                        ExpenseInbox.Status := ExpenseInbox.Status::Pending;
                        ExpenseInbox.Modify;
                    end;
                end;

            DATABASE::"CEM Mileage Inbox":
                begin
                    MileageInbox.Get("Doc. Ref. No.");
                    if MileageInbox.Status = MileageInbox.Status::Error then begin
                        MileageInbox.Status := MileageInbox.Status::Pending;
                        MileageInbox.Modify;
                    end;
                end;

            DATABASE::"CEM Per Diem Inbox":
                begin
                    PerDiemInbox.Get("Doc. Ref. No.");
                    if PerDiemInbox.Status = PerDiemInbox.Status::Error then begin
                        PerDiemInbox.Status := PerDiemInbox.Status::Pending;
                        PerDiemInbox.Modify;
                    end;
                end;

            DATABASE::"CEM Expense Header Inbox":
                begin
                    ExpHeaderInbox.Get("Doc. Ref. No.");
                    if ExpHeaderInbox.Status = ExpHeaderInbox.Status::Error then begin
                        ExpHeaderInbox.Status := ExpHeaderInbox.Status::Pending;
                        ExpHeaderInbox.Modify;
                    end;
                end;
        end;
    end;


    procedure EMDimInboxUpdated(var EMDimInbox: Record "CEM Dimension Inbox"; TableID: Integer; DocType: Integer; DocNo: Code[20]; DocRefNo: Integer): Boolean
    var
        xEMDimInbox: Record "CEM Dimension Inbox";
    begin
        EMDimInbox.Reset;
        EMDimInbox.SetRange("Table ID", TableID);
        EMDimInbox.SetRange("Document Type", DocType);
        EMDimInbox.SetRange("Document No.", DocNo);
        EMDimInbox.SetRange("Doc. Ref. No.", DocRefNo);

        xEMDimInbox.Reset;
        xEMDimInbox.SetRange("Table ID", TableID);
        xEMDimInbox.SetRange("Document Type", DocType);
        xEMDimInbox.SetRange("Document No.", DocNo);
        xEMDimInbox.SetRange("Doc. Ref. No.", DocRefNo);

        if EMDimInbox.FindSet then
            repeat
                if not xEMDimInbox.Get(TableID, DocType, DocNo, DocRefNo, EMDimInbox."Dimension Code", EMDimInbox."Field Code") then
                    exit(true);

                if (EMDimInbox."Dimension Value Code" <> xEMDimInbox."Dimension Value Code") or
                   (EMDimInbox."Field Value" <> xEMDimInbox."Field Value")
                then
                    exit(true);
            until EMDimInbox.Next = 0;

        if xEMDimInbox.FindSet then
            repeat
                if not EMDimInbox.Get(TableID, DocType, DocNo, DocRefNo, xEMDimInbox."Dimension Code", xEMDimInbox."Field Code") then
                    exit(true);
            until xEMDimInbox.Next = 0;
    end;

    local procedure UpdateRecordGlobalDimValue(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; DimCode: Code[20]; DimValCode: Code[20])
    var
        ExpAllocInbox: Record "CEM Expense Allocation Inbox";
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
        ExpInbox: Record "CEM Expense Inbox";
        MilInbox: Record "CEM Mileage Inbox";
        PerDiemInbox: Record "CEM Per Diem Inbox";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        if not (DimCode in [GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code"]) then
            exit;

        case TableID of
            DATABASE::"CEM Expense Inbox":
                begin
                    ExpInbox.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        ExpInbox."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        ExpInbox."Global Dimension 2 Code" := DimValCode;
                    ExpInbox.Modify;
                end;

            DATABASE::"CEM Mileage Inbox":
                begin
                    MilInbox.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        MilInbox."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        MilInbox."Global Dimension 2 Code" := DimValCode;
                    MilInbox.Modify;
                end;

            DATABASE::"CEM Per Diem Inbox":
                begin
                    PerDiemInbox.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        PerDiemInbox."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        PerDiemInbox."Global Dimension 2 Code" := DimValCode;
                    PerDiemInbox.Modify;
                end;

            DATABASE::"CEM Expense Header Inbox":
                begin
                    ExpHeaderInbox.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        ExpHeaderInbox."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        ExpHeaderInbox."Global Dimension 2 Code" := DimValCode;
                    ExpHeaderInbox.Modify;
                end;

            DATABASE::"CEM Expense Allocation Inbox":
                begin
                    ExpAllocInbox.Get(DocRefNo);
                    if DimCode = GLSetup."Global Dimension 1 Code" then
                        ExpAllocInbox."Global Dimension 1 Code" := DimValCode;
                    if DimCode = GLSetup."Global Dimension 2 Code" then
                        ExpAllocInbox."Global Dimension 2 Code" := DimValCode;
                    ExpAllocInbox.Modify;
                end;
        end;
    end;
}

