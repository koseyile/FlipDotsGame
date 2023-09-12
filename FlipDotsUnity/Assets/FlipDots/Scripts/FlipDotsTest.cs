using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SerialPortUtility;

#pragma warning disable IDE0058 // 永远不会使用表达式值
#pragma warning disable format

public class FlipDotsTest : MonoBehaviour
{
  public SerialPortUtilityPro SerialPort;
  private byte PanelValue_1 = 0xFF;
  private byte PanelValue_2 = 0xFF;
  // Start is called before the first frame update
  void Start()
  {
        
  }

  // Update is called once per frame
  void Update()
  {
    if (Input.GetKeyDown(KeyCode.Alpha1))
    {
      SendDataToFlipDots(1, PanelValue_1);
      if (PanelValue_1==0xFF)
      {
        PanelValue_1 = 0x00;
      }
      else
      {
        PanelValue_1 = 0xFF;
      }
    }

    if (Input.GetKeyDown(KeyCode.Alpha2))
    {
      SendDataToFlipDots(2, PanelValue_2);
      if (PanelValue_2 == 0xFF)
      {
        PanelValue_2 = 0x00;
      }
      else
      {
        PanelValue_2 = 0xFF;
      }
    }
  }

  private void SendDataToFlipDots(byte id, byte value)
  {
    SerialPort.Write(0x80);
    SerialPort.Write(0x84);
    SerialPort.Write(id);


    byte[] buffer = new byte[28];
    for (int i = 0; i < buffer.Length; i++)
    {
      buffer[i] = value;
    }
    SerialPort.Write(buffer);
    SerialPort.Write(0x8F);

    SerialPort.Write(0x80);
    SerialPort.Write(0x82);
    SerialPort.Write(0x8F);

}
}

#pragma warning restore format
#pragma warning restore IDE0058 // 永远不会使用表达式值
