table 6086229 "CTS-CDN Document"
{
    Caption = 'Network Document';

    fields
    {
        field(1; "System ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'System ID';
        }
        field(2; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
        }
        field(3; "Sender ID Type ID"; Integer)
        {
            Caption = 'Sender ID Type';
        }
        field(4; "Sender ID Value"; Text[250])
        {
            Caption = 'Sender ID';
        }
        field(5; "Receiver ID Type ID"; Integer)
        {
            Caption = 'Receiver ID Type';
        }
        field(6; "Receiver ID Value"; Text[250])
        {
            Caption = 'Receiver ID';
        }
        field(7; "Network Profile ID"; Integer)
        {
            Caption = 'Network Profile ID';
        }
        field(8; "Source Record ID"; RecordID)
        {
            Caption = 'Source Record ID';
        }
        field(9; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Incoming,Outgoing';
            OptionMembers = Incoming,Outgoing;
        }
        field(10; "XML File"; BLOB)
        {
            Caption = 'XML File';
        }
        field(11; "XML File Base Url"; Text[250])
        {
            Caption = 'XML File Base Url';
        }
        field(12; "XML File Token"; Text[250])
        {
            Caption = 'XML File Token';
        }
        field(13; "Transport XML File"; BLOB)
        {
            Caption = 'Transport XML File';
        }
        field(14; "Transport XML File Base Url"; Text[250])
        {
            Caption = 'Transport XML File Base Url';
        }
        field(15; "Transport XML File Token"; Text[250])
        {
            Caption = 'Transport XML File Token';
        }
        field(16; "HTML File"; BLOB)
        {
            Caption = 'HTML File';
        }
        field(20; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
        field(21; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Draft,InProcess,Sent,Failed,Successful';
            OptionMembers = Draft,InProcess,Sent,Failed,Successful;
        }
        field(22; Created; DateTime)
        {
            Caption = 'Created Date-Time';
        }
        field(23; Updated; DateTime)
        {
            Caption = 'Updated Date-Time';
        }
        field(24; "Particip. Profile Rel. GUID"; Guid)
        {
            Caption = 'Participation Profile Relation GUID';
        }
        field(30; "CDC Processed"; Boolean)
        {
            Caption = 'Processed by Document Capture';
        }
        field(31; "Doc. Cat. Code"; Code[20])
        {
            Caption = 'Profile Document Category Code';
        }
        field(40; "CDN Document"; Boolean)
        {
            Caption = 'Network Document';
        }
        field(41; "Network Profile Desc"; Text[250])
        {
            CalcFormula = Lookup("CTS-CDN Network Profile".Description WHERE("System ID" = FIELD("Network Profile ID")));
            Caption = 'Network Profile';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Receiver Scheme ID"; Text[50])
        {
            CalcFormula = Lookup("CTS-CDN Participation ID Type"."Scheme ID" WHERE("System ID" = FIELD("Receiver ID Type ID")));
            Caption = 'Receiver Type ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Sender Scheme ID"; Text[50])
        {
            CalcFormula = Lookup("CTS-CDN Participation ID Type"."Scheme ID" WHERE("System ID" = FIELD("Sender ID Type ID")));
            Caption = 'Sender Type ID';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "System ID")
        {
            Clustered = true;
        }
        key(Key2; "Network Profile ID", "Source Record ID")
        {
        }
        key(Key3; "Network Profile ID", "Source Record ID", Status)
        {
        }
        key(Key4; "CDN GUID")
        {
        }
    }

    fieldgroups
    {
    }

    procedure FindDocumentByGUID(CDNGUID: Guid): Boolean
    begin
        SetRange("CDN GUID", CDNGUID);
        exit(FindFirst);
    end;


    procedure SetElectronicXmlDoc(var XmlDoc: Codeunit "CSC XML Document")
    var
        WriteStream: OutStream;
    begin
        Clear("XML File");
        "XML File".CreateOutStream(WriteStream);
        XmlDoc.SaveToStream(WriteStream);
    end;


    procedure GetParticipProfileRelationId(): Guid
    var
        CDNParticipProfileRel: Record "CTS-CDN Particip. Profile Rel.";
    begin
        CDNParticipProfileRel.SetRange("Network Name", "Network Name");
        CDNParticipProfileRel.SetRange("Participation Identifier Type", "Sender ID Type ID");
        CDNParticipProfileRel.SetRange("Participation Identifier Value", "Sender ID Value");
        CDNParticipProfileRel.SetRange("Profile System ID", "Network Profile ID");
        CDNParticipProfileRel.FindFirst;
        exit(CDNParticipProfileRel."CDN GUID");
    end;

    procedure GetSenderDisplayName(): Text[1024]
    var
        Network: Record "CTS-CDN Network";
        ParticipationIDType: Record "CTS-CDN Participation ID Type";
    begin
        Network.Get("Network Name");
        ParticipationIDType.Get("Sender ID Type ID");

        exit(StrSubstNo('%1 - [%2] %3', Network."Display Name", ParticipationIDType."Scheme ID", "Sender ID Value"));
    end;

    procedure GetXmlFileAsStream(var ReadStream: InStream)
    begin
        Rec.CalcFields("XML File");
        if not Rec."XML File".HasValue then
            DownloadXmlFileFromUrl;

        Rec."XML File".CreateInStream(ReadStream);
    end;


    procedure DownloadXmlFileFromUrl()
    var
        CDNFileMgt: Codeunit "CTS-CDN File Management";
        WriteStream: OutStream;
        BaseUrl: Text[1024];
    begin
        Rec."XML File".CreateOutStream(WriteStream);
        CDNFileMgt.DownloadToStream(Rec."XML File Base Url" + Rec."XML File Token", WriteStream);
        Rec.Modify(true);
    end;

    local procedure GetTransportXMLFromUrl()
    begin
    end;

    procedure GetGUIDAsText(): Text[36]
    begin
        exit(DelChr(Rec."CDN GUID", '<>', '{}'))
    end;


    procedure ValidateCDNStatus(CDNStatusEnum: Text[1024])
    begin
        case CDNStatusEnum of
            'CreatedEnum':
                Validate(Status, Status::Draft);
            'InProcessEnum', 'RetryEnum', 'WaitingEnum':
                Validate(Status, Status::InProcess);
            'SuccessEnum':
                Validate(Status, Status::Successful);
            'ErrorEnum':
                Validate(Status, Status::Failed);
        end;
    end;


    procedure ValidateCDNDirection(CDNDirectionEnum: Text[1024])
    begin
        case CDNDirectionEnum of
            'IncomingEnum':
                Validate(Direction, Direction::Incoming);
            'OutgoingEnum':
                Validate(Direction, Direction::Outgoing);
        end;
    end;


    procedure OpenXmlFile()
    var
        TempBlob: Record "CSC Temp Blob" temporary;
        CDNFileMgt: Codeunit "CTS-CDN File Management";
        Success: Boolean;
    begin
        TempBlob.Init;
        Rec.CalcFields("XML File");
        TempBlob.Blob := Rec."XML File";
        CDNFileMgt.SaveFileWithDialog(TempBlob, GetGUIDAsText + '.xml', 'Download', 'File (*.xml)|*.xml', Success);
    end;

    procedure GetNetworkProfileDesc(): Text[250]
    var
        NetworkProfile: Record "CTS-CDN Network Profile";
    begin
        if NetworkProfile.Get(Rec."Network Profile ID") then
            exit(NetworkProfile.Description);
    end;


    procedure GetGUIDFilename(): Text[1024]
    begin
        exit(StrSubstNo('%1.xml', GetGUIDAsText));
    end;


    procedure FindDocumentFromRecord(FromRecord: Variant): Boolean
    var
        RecId: RecordID;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(FromRecord);
        RecId := RecRef.RecordId;

        SetRange("Source Record ID", RecId);
        SetRange(Direction, Direction::Outgoing);
        exit(FindLast);
    end;
}

