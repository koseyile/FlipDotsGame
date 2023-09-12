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

  private int numColumns = 14;
  private int numRows = 28;
  private byte[] mBuffer1;
  private byte[] mBuffer2;

  private void Awake()
  {
    mBuffer1 = new byte[numRows];
    mBuffer2 = new byte[numRows];
  }
  // Start is called before the first frame update
  void Start()
  {
    StartCoroutine(FlipDotsAnimation());
        
  }

  IEnumerator FlipDotsAnimation()
  {
    while (true)
    {
      yield return new WaitForSeconds(0.1f);
      
      ClearDotsState();
      CopyColorFromRenderTexture(CameraDots.Instance.DotsRT);
      //SetDotState(0, 1, true);
      //SetDotState(2, 2, true);
      //SetDotState(13, 27, true);

      UpdateFlipDots();
    }

    yield return null;
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
    byte[] buffer = new byte[28];
    for (int i = 0; i < buffer.Length; i++)
    {
      buffer[i] = value;
    }
    SendDataToFlipDots(id, buffer);
  }

  private void SendDataToFlipDots(byte id, byte[] buffer)
  {
    SerialPort.Write(0x80);
    SerialPort.Write(0x84);
    SerialPort.Write(id);

    SerialPort.Write(buffer);
    SerialPort.Write(0x8F);

    SerialPort.Write(0x80);
    SerialPort.Write(0x82);
    SerialPort.Write(0x8F);
  }

  private void UpdateFlipDots()
  {
    SendDataToFlipDots(1, mBuffer1);
    SendDataToFlipDots(2, mBuffer2);
  }

  private void CopyColorFromRenderTexture(RenderTexture rt)
  {
    RenderTexture.active = rt;
    Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);

    texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
    texture2D.Apply();

    RenderTexture.active = null;

    ClearDotsState();

    float xScale = numColumns / (float)rt.width;
    float yScale = numRows / (float)rt.height;

    for (int x = 0; x < rt.width; x++)
    {
      for (int y = 0; y < rt.height; y++)
      {
        Color c = texture2D.GetPixel(x, y);
        if (c.grayscale > 0.5f)
        {
          int xIndex = (int)(x * xScale);
          int yIndex = (int)((rt.height-y) * yScale);

          int currentState = GetDotState(xIndex, yIndex);
          if (currentState != 1)
          {
            SetDotState(xIndex, yIndex, true);
          }

        }
      }
    }

    GameObject.Destroy(texture2D);
  }

  private void ClearDotsState()
  {
    for (int i = 0; i < mBuffer1.Length; i++)
    {
      mBuffer1[i] = 0x00;
      mBuffer2[i] = 0x00;
    }
  }

  private void SetDotState(int x, int y, bool state)
  {
    if(x<0 || x>=numColumns)
    {
      return;
    }
    
    if(y<0 || y>=numRows)
    {
      return;
    }
    
    byte[] buffer = mBuffer1;
    if(x>6)
    {
      buffer = mBuffer2;
    }
    
    byte v1 = buffer[y];
    byte v2 = (byte)(1 << (6-x%7));
    if(state==false)
    {
      v2 = (byte) (v2 ^ 0xFF);
      v1 &= v2;
    }else{
      v1 |= v2;
    }
    
    buffer[y] = v1;
  }

  private int GetDotState(int x, int y)
  {
    if (x < 0 || x >= numColumns)
    {
      return -1;
    }

    if (y < 0 || y >= numRows)
    {
      return -1;
    }

    byte[] buffer = mBuffer1;
    if (x > 6)
    {
      buffer = mBuffer2;
    }

    byte v1 = buffer[y];
    byte v2 = (byte)(1 << (6 - x % 7));


    int r = v1 & v2;
    return r;
  }

}

#pragma warning restore format
#pragma warning restore IDE0058 // 永远不会使用表达式值
