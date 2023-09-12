using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CameraDots : MonoBehaviour
{
  static public CameraDots Instance;
  public RawImage DotsRTImage;
  public RenderTexture DotsRT;
 
  private void Awake()
  {
    Instance = this;
    DotsRT = new RenderTexture(140, 280, 0, RenderTextureFormat.ARGB32);
    DotsRTImage.texture = DotsRT;
  }
  // Start is called before the first frame update
  void Start()
  {
    
  }

  // Update is called once per frame
  void Update()
  {
        
  }

  private void OnRenderImage(RenderTexture source, RenderTexture destination)
  {
    Graphics.Blit(source, DotsRT);
    Graphics.Blit(source, destination);
  }
}
