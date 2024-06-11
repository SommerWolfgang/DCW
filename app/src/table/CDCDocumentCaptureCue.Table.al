table 6085585 "CDC Document Capture Cue"
{
    Caption = 'Document Capture Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Documents to Register"; Integer)
        {
            CalcFormula = Count("CDC Document" WHERE(Status = CONST(Open),
                                                      "File Type" = FILTER(OCR | XML)));
            Caption = 'Documents to Register';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "PIs for Approval"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         Status = FILTER("Pending Approval")));
            Caption = 'PIs for Approval';
            FieldClass = FlowField;
        }
        field(5; "Open PIs"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         Status = CONST(Open)));
            Caption = 'Open PIs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Released PIs"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         Status = CONST(Released)));
            Caption = 'Released PIs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Overdue PIs"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         "Due Date" = FIELD("Date Filter")));
            Caption = 'Overdue Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Overdue Approval Entries"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(38),
                                                        "Document Type" = FILTER(Invoice | "Credit Memo"),
                                                        Status = FILTER(Created | Open),
                                                        "Due Date" = FIELD("Date Filter")));
            Caption = 'Overdue Approval Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(10; "PCMs for Approval"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         Status = FILTER("Pending Approval")));
            Caption = 'PCMs for Approval';
            FieldClass = FlowField;
        }
        field(11; "Open PCMs"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         Status = CONST(Open)));
            Caption = 'Open PCMs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Released PCMs"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         Status = CONST(Released)));
            Caption = 'Released PCMs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Delegated Docs"; Integer)
        {
            CalcFormula = Count("CDC Document" WHERE(Status = FIELD("Status Filter"),
                                                      "Delegated To User ID" = FIELD("Delegated User ID Filter")));
            Caption = 'Delegated to me';
            FieldClass = FlowField;
        }
        field(14; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(15; "Status Filter"; Option)
        {
            Caption = 'Status Filter';
            Editable = false;
            FieldClass = FlowFilter;
            OptionCaption = 'Open,Registered,Rejected';
            OptionMembers = Open,Registered,Rejected;
        }
        field(16; "Delegated User ID Filter"; Code[50])
        {
            Caption = 'Delegated User ID Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure DrillDownPurchHeader(Type: Integer; Status: Integer)
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type", Type);
        PurchHeader.SetRange(Status, Status);
        if Type = PurchHeader."Document Type"::Invoice then
            PAGE.Run(6085725, PurchHeader)
        else
            PAGE.Run(6085726, PurchHeader);
    end;


    procedure DrillDownOverdueApprEntries()
    var
        ApprovalEntry: Record "Approval Entry";
        PurchHeader: Record "Purchase Header";
    begin
        ApprovalEntry.FilterGroup(2);
        ApprovalEntry.SetRange("Table ID", DATABASE::"Purchase Header");
        ApprovalEntry.SetFilter("Document Type", '%1|%2', ApprovalEntry."Document Type"::Invoice,
          ApprovalEntry."Document Type"::"Credit Memo");
        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
        ApprovalEntry.SetFilter("Due Date", GetFilter("Date Filter"));
        ApprovalEntry.FilterGroup(0);
    end;


    procedure DrillDownOverduePI()
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetFilter("Due Date", GetFilter("Date Filter"));
        PAGE.Run(6085725, PurchHeader);
    end;
}

